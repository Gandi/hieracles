
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

	end
end
