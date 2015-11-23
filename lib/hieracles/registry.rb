
module Hieracles
  module Registry
  	extend self

  	def farms(config)
  		@_farms ||= Dir.glob(format(config.classpath, '*')).sort
  	end

  	def nodes(config)
  		@_nodes ||= Dir.glob(File.join(config.encpath, '*.yaml')).sort.map do |f|
  			File.basename(f, '.yaml')
  		end
  	end

  	def modules(config)
  		@_modules ||= Dir.glob(File.join(config.modulepath, '*')).sort.map do |f|
  			File.basename(f)
  		end
  	end

	end
end
