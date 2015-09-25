
module Hieracles
  module Registry
  	extend self

  	def farms(config)
  		@_farms ||= Dir.glob(File.join(config.basepath, format(config.classpath, '*')))
  	end

  	def nodes(config)
  		@_nodes ||= Dir.glob(File.join(config.basepath, config.encpath, '*.yaml')).map do |f|
  			File.basename(f, '.yaml')
  		end
  	end

  	def modules(config)
  		@_modules ||= Dir.glob(File.join(config.basepath, config.modulepath, '*')).map do |f|
  			File.basename(f)
  		end
  	end

	end
end