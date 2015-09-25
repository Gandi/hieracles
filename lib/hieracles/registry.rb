
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

	end
end