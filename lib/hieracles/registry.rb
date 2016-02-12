
module Hieracles
  module Registry
  	extend self

  	def farms(config)
  		Dir.glob(format(config.classpath, '*')).sort.map do |f|
        sub = Regexp.new(".*#{config.classpath.sub(/%s/,'([^/]*)')}")
        f.sub(sub, "\\1")
      end
  	end

    def nodes(config)
      Dir.glob(File.join(config.encpath, '*.yaml')).sort.map do |f|
        File.basename(f, '.yaml')
      end
    end

    def modules(config)
      Dir.glob(File.join(config.modulepath, '*')).sort.map do |f|
        File.basename(f)
      end
    end

    def nodes_data(config, env = 'production', reload = false)
      @_nodes_data = {} if reload || !@_nodes_data
      @_nodes_data[env] ||= Dir.glob(File.join(config.encpath, '*.yaml')).sort.reduce({}) do |a, f|
        fqdn = File.basename(f, '.yaml')
        a[fqdn] = YAML.load_file(f)['parameters']
        a
      end
    end

    def farms_counted(config, env = 'production')
      Dir.glob(format(config.classpath, '*')).sort.reduce({}) do |a, f|
        sub = Regexp.new(".*#{config.classpath.sub(/%s/,'([^/]*)')}")
        name = f.sub(sub, "\\1")
        a[name] = nodes_data(config, env).select { |k, v| v['farm'] == name }.length
        a
      end
    end

	end
end
