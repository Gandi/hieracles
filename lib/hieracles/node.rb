require "net/http"
require "uri"
require "yaml"
require 'deep_merge'

module Hieracles
  class Node
    include Hieracles::Utils
    include Hieracles::Interpolate

    attr_reader :hiera_params, :hiera, :facts, :notifications

    def initialize(fqdn, options)
      @fqdn = fqdn
      Config.load(options)
      @hiera = Hieracles::Hiera.new
      @hiera_params = { fqdn: fqdn }.
        merge(get_hiera_params(fqdn)).
        merge(Config.extraparams)
      @facts = @hiera_params.
        merge(Config.scope).
        merge(puppet_facts)
    end

    def get_hiera_params(fqdn)
      if File.exist?(File.join(Config.path('encpath'), "#{fqdn}.yaml"))
        load = YAML.load_file(File.join(Config.path('encpath'), "#{fqdn}.yaml"))
        sym_keys(load['parameters']).merge({ classes: load['classes']})
      else
        raise "Node not found"
      end
    end

    def files(without_common = true)
      @__files ||= @hiera.hierarchy.reduce([]) do |a, f|
        file = parse("#{f}.yaml", @facts, Config.interactive)
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
      files(without_common).map { |p| File.join(Config.basepath, p) }
    end

    def params(without_common = true)
      params = {}
      files(without_common).reverse.each do |f|
        data = YAML.load_file(File.join(Config.basepath, f))
        if data
          s = to_shallow_hash(data)
          s.each do |k,v|
            params[k] ||= []
            # f needs interpolation
            params[k] << { value: v, file: f, merged: merge_value(params[k], v) }
          end
        end
      end
      params.sort
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
      if Config.usedb
        extra = puppetdb_info
      end
      @hiera_params.merge extra
    end

    def classfiles
      @hiera_params[:classes].map do |cl|
        format(Config.path('classpath'), cl)
      end
    end

    def modulepath(path)
      File.join(Config.modulepath, path)
    end

    def add_modules(line, modules)
      if /^\s*include\s*([-_:a-zA-Z0-9]*)\s*/.match(line)
        mod = $1
        mainmod = mod[/^[^:]*/]
        if Dir.exists? modulepath(mainmod)
          modules[mod] = File.join(Config.modulepath, mainmod)
        else
          modules[mod] = nil
        end
      end
      modules
    end

    def puppetdb_info
      resp = puppetdb.request("nodes/#{@fqdn}")
      resp.data
    end

    def puppet_facts
      if Config.usedb
        resp = puppetdb.request("nodes/#{@fqdn}/facts")
        @notifications = resp.notifications
        if resp.total_records > 0
          resp.data.reduce({}) do |a, v|
            a[v['name'].to_sym] = v['value']
            a
          end
        else
          error "not found in puppetdb."
          {}
        end
      else
        {}
      end
    end

    def puppetdb
      @_puppetdb ||= Hieracles::Puppetdb::Client.new Config.puppetdb
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
          deep_sort(value)
        else
          left = previous.last[:merged]
          case @hiera.merge_behavior
          # TODO: handle the case where right is not an array
          when :deeper
            deep_sort(left | value)
          when :deep
            deep_sort(left | value)
          else
            deep_sort(value)
          end
        end
      else
        value
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
