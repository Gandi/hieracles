require "net/http"
require "uri"
require "yaml"

module Hieracles
  class Node
    include Hieracles::Utils

    attr_reader :hiera_params, :hiera

    def initialize(fqdn, options)
      Config.load(options)
      @hiera = Hieracles::Hiera.new
      @hiera_params = { fqdn: fqdn }.
        merge(get_hiera_params(fqdn)).
        merge(Config.extraparams)
      @fqdn = fqdn
    end

    def get_hiera_params(fqdn)
      if File.exist?(File.join(Config.path('encpath'), "#{fqdn}.yaml"))
        load = YAML.load_file(File.join(Config.path('encpath'), "#{fqdn}.yaml"))
        sym_keys(load['parameters'])
      else
        raise "Node not found"
      end
    end

    def files
      @hiera.hierarchy.reduce([]) do |a, f|
        file = format("#{f}.yaml", @hiera_params) rescue nil
        if file && File.exist?(File.join(@hiera.datadir, file))
          a << file
        end
        a
      end
    end

    def paths
      files.map { |p| File.join(@hiera.datadir, p) }
    end

    def params
      params = {}
      paths.each do |f|
        data = YAML.load_file(f)
        s = to_shallow_hash(data)
        s.each do |k,v|
          params[k] ||= []
          params[k] << { value: v, file: f}
        end
      end
      params.sort
    end

    def params_tree
      params = {}
      paths.each do |f|
        data = YAML.load_file(f)
        deep_merge!(params, data)
      end
      deep_sort(params)
    end

    def modules
     if File.exist?(classfile)
        modules = {}
        f = File.open(classfile, "r")
        f.each_line do |line|
          modules = add_modules(line, modules)
        end
        f.close
        modules
      else
        raise "Class file #{classfile} not found."
      end
    end

    def info
      @hiera_params
    end

    def classfile
      format(Config.path('classpath'), @hiera_params[:farm])
    end

    def modulepath(path)
      File.join(Config.path('modulepath'), path)
    end

    def add_modules(line, modules)
      if /^\s*include\s*([-_:a-zA-Z0-9]*)\s*/.match(line)
        mod = $1
        mainmod = mod[/^[^:]*/]
        if Dir.exists? modulepath(mainmod)
          modules[mod] = File.join(Config.path('modulepath'), mainmod)
        else
          modules[mod] = nil
        end
      end
      modules
    end

  end
end
