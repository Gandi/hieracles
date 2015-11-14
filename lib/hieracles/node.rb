require "net/http"
require "uri"
require "yaml"

module Hieracles
  class Node
    include Hieracles::Utils
    include Hieracles::Interpolate

    attr_reader :hiera_params, :hiera

    def initialize(fqdn, options)
      Config.load(options)
      @hiera = Hieracles::Hiera.new
      @hiera_params = { fqdn: fqdn }.
        merge(get_hiera_params(fqdn)).
        merge(Config.scope).
        merge(Config.extraparams)
      @fqdn = fqdn
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
        file = parse("#{f}.yaml", @hiera_params, Config.interactive)
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
      files(without_common).each do |f|
        data = YAML.load_file(File.join(Config.basepath, f))
        if data
          s = to_shallow_hash(data)
          s.each do |k,v|
            params[k] ||= []
            # f needs interpolation
            params[k] << { value: v, file: f}
          end
        end
      end
      params.sort
    end

    def params_tree(without_common = true)
      params = {}
      paths(without_common).each do |f|
        data = YAML.load_file(f)
        if data
          # data needs interpolation
          deep_merge!(params, data)
        end
      end
      deep_sort(params)
    end

    def modules
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
      @hiera_params
    end

    def classfiles
      @hiera_params[:classes].map do |cl|
        format(Config.path('classpath'), cl)
      end
    end

    def modulepath(path)
      File.join(Config.path('modulepath'), path)
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

  end
end
