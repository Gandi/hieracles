require "net/http"
require "uri"
require "yaml"
require 'deep_merge'

module Hieracles
  class Node
    include Hieracles::Utils
    include Hieracles::Interpolate

    attr_reader :hiera_params, :hiera, :facts, :notifications

    def initialize(fqdn, config)
      @fqdn = fqdn
      @config = config
      @hiera = Hieracles::Hiera.new @config
      @hiera_params = { fqdn: @fqdn }.
        merge(get_hiera_params(@fqdn)).
        merge(@config.extraparams)
      @facts = deep_sort(@config.scope.
        merge(puppet_facts).
        merge(@hiera_params)
        )
    end

    def get_hiera_params(fqdn)
      @__hiera_params ||= if File.exist?(File.join(@config.encpath, "#{fqdn}.yaml"))
        load = YAML.load_file(File.join(@config.encpath, "#{fqdn}.yaml"))
        sym_keys(load['parameters']).merge({ classes: load['classes']})
      else
        raise "Node not found"
      end
    end

    def files(without_common = true)
      @__files ||= @hiera.hierarchy.reduce([]) do |a, f|
        file = parse("#{f}.yaml", @facts, @config.interactive)
        if file && 
           File.exist?(File.join(@hiera.datapath, file)) &&
           (!without_common ||
           !file[/common/])
          a << File.join(@hiera.datadir, file)
        end
        a
      end
    end

    def paths(without_common = true)
      files(without_common).map { |p| File.join(@config.basepath, p) }
    end

    def params(without_common = true)
      params = {}
      files(without_common).each do |f|

        # Patch to work on ruby3.2.0
        begin
          data = YAML.load_file(File.join(@config.basepath, f), aliases: true)
        rescue ArgumentError
          data = YAML.load_file(File.join(@config.basepath, f))
        end

        if data
          s = to_shallow_hash(data)
          s.each do |k,v|
            if params[k]
              case @hiera.merge_behavior
              when :deeper
                params[k] = { value: v }.deep_merge!(params[k])
              when :deep
                params[k].deep_merge({ value: v })
              end
              params[k][:file] = '-'
              params[k][:overriden] = true
              params[k][:found_in].push({ value: v, file: f })
            else
              params[k] = {
                value: v,
                file: f,
                overriden: false,
                found_in: [{ value: v, file: f }]
              }
            end
          end
        end
      end
      params.sort.to_h
    end

    def params_tree(without_common = true)
      params = {}
      paths(without_common).reverse.each do |f|
        data = YAML.load_file(f) || {}
        merge_trees params, data
      end
      deep_sort(params)
    end

    def modules
      @_modules ||= _get_modules
    end

    def _get_modules
      modules = {}
      classfiles.each do |c|
        if File.exist?(c)
          f = File.open(c, "r")
          f.each_line do |line|
            modules = add_modules(line, modules)
          end
          f.close
        else
          raise "Class file #{c} not found."
        end
      end
      modules
    end

    def info
      @_info ||= _get_info
    end

    def _get_info
      extra = {}
      if @config.usedb
        extra = puppetdb_info
      end
      @hiera_params.merge extra
    end

    def classfiles
      @hiera_params[:classes].map do |cl|
        format(@config.classpath, cl)
      end
    end

    def modulepath(path)
      File.join(@config.modulepath, path)
    end

    def add_modules(line, modules)
      if /^\s*include\s*([-_:a-zA-Z0-9]*)\s*/.match(line)
        mod = $1
        mainmod = mod[/^[^:]*/]
        if Dir.exists? modulepath(mainmod)
          modules[mod] = File.join(@config.modulepath, mainmod)
        else
          modules[mod] = nil
        end
      end
      modules
    end

    def puppetdb_info
      request_db.node_info(@fqdn).data
    end

    def puppet_facts
      if @config.usedb
        resp = request_db.node_facts(@fqdn)
        @notifications = resp.notifications
        if resp.total_records > 0
          resp.data
        else
          error "not found in puppetdb."
          {}
        end
      else
        {}
      end
    end

    def request_db
      @_request ||= Hieracles::Puppetdb::Request.new @config.puppetdb
    end

    def merge_trees(left, right)
      case @hiera.merge_behavior
      when :deeper
        left.deep_merge!(right)
      when :deep
        left.deep_merge(right)
      else
        local_merge!(left, right)
      end
    end

    def merge_value(previous, value)
      if value.is_a? Array
        if previous == []
          { merged: deep_sort(value) }
        else
          left = { merged: previous.last[:merged] }
          right = { merged: value }
          case @hiera.merge_behavior
          # TODO: handle the case where right is not an array
          when :deeper
            deep_sort(left.deep_merge!(right))
          when :deep
            deep_sort(left.deep_merge(right))
          else
            deep_sort(right)
          end
        end
      else
        { merged: value }
      end
    end

    def error(message)
      if @notifications
        @notifications << Notification.new('node', message, 'error')
      else
        @notifications = [ Notification.new('node', message, 'error') ]
      end
    end

  end
end
