
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

    def vars(config)
      
    end

	end
end
