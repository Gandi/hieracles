
module Hieracles
  module Registry
  	extend self

  	def farms(config)
  		Dir.glob(format(config.classpath, '*')).sort.map do |f|
        extract_path = Regexp.new(".*#{config.classpath.sub(/%s/,'([^/]*)')}")
        f.sub(extract_path, "\\1")
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

    def reload_nodes()
      @_nodes_parameters = {}
      @_nodes_modules = {}
      @_farms_modules = {}
    end

    def nodes_parameters(config, env = 'production')
      @_nodes_parameters ||= {}
      @_nodes_parameters[env] ||= Dir.glob(File.join(config.encpath, '*.yaml')).sort.reduce({}) do |a, f|
        fqdn = File.basename(f, '.yaml')
        a[fqdn] = YAML.load_file(f)['parameters']
        a
      end
    end

    def farms_modules(config, env = 'production')
      @_farms_modules ||= {}
      regex = Regexp.new('\s*include\s*([-_a-z0-9]*)')
      extract_path = Regexp.new(".*#{config.classpath.sub(/%s/,'([^/]*)')}")
      @_farms_modules[env] ||= Dir.glob(format(config.classpath, '*')).sort.reduce({}) do |a, f|
        name = f.sub(extract_path, "\\1")
        a[name] = find_item(f, regex)
        a
      end
    end

    def nodes_modules(config, env = 'production')
      @_nodes_modules ||= {}
      @_nodes_modules[env] ||= Dir.glob(File.join(config.encpath, '*.yaml')).sort.reduce({}) do |a, f|
        YAML.load_file(f)['classes'].each do |cl|

        end
        fqdn = File.basename(f, '.yaml')
        a[fqdn] = YAML.load_file(f)['parameters']
        a
      end
    end

    def farms_counted(config, env = 'production', reload = false)
      reload_nodes if reload
      extract_path = Regexp.new(".*#{config.classpath.sub(/%s/,'([^/]*)')}")
      Dir.glob(format(config.classpath, '*')).sort.reduce({}) do |a, f|
        name = f.sub(extract_path, "\\1")
        a[name] = nodes_parameters(config, env).select { |k, v| v['farm'] == name }.length
        a
      end
    end

    def modules_counted(config, env = 'production', reload = false)
      reload_nodes if reload
      extract_path = Regexp.new(".*#{config.classpath.sub(/%s/,'([^/]*)')}")
      Dir.glob(File.join(config.modulepath, '*')).sort.reduce({}) do |acc, mod|

        acc
      end
    end

    def find_item(file, regexp)
      File.readlines(file).reduce([]) do |acc, line|
        if regexp.match line
          acc.push $1
        end
        acc
      end
    end

	end
end
