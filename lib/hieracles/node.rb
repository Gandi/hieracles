require "net/http"
require "uri"
require "yaml"

module Hieracles

	class Node

		include Hieracles::Utils

		attr_reader :fqdn, :farm, :datacenter, :country, :files, :classfile

		def initialize(fqdn, options)
			@fqdn = fqdn
			@files = []
			Config.load(options)
			populate_info(fqdn)
			populate_files
		end

		def paths
			@files.map { |p| File.expand_path(p) }
		end

		def params
			@_populated_params ||= populate_params
		end

		def modules
			@_populated_modules ||= populate_modules
		end

		def add_common
			addfile "params/common/common.yaml"
		end

	private

		def populate_info(fqdn)
			# temporary solution
			if Dir.exist?('enc')
				populate_from_encdir(fqdn)
			else
				populate_from_cgi(fqdn)
			end
		end

		def populate_from_encdir(fqdn)
			if File.exist?(File.join('enc', "#{fqdn}.yaml"))
				load = YAML.load_file(File.join('enc', "#{fqdn}.yaml"))
				@farm = load['parameters']['farm']
				@datacenter = load['parameters']['datacenter']
				@country = load['parameters']['country']
			else
				puts "Node not found"
			end
		end

		def populate_from_cgi(fqdn)
			uri = URI.parse("http://#{Config.server}/cgi-bin/nodeinfo?q=#{fqdn}")
			res = Net::HTTP.get_response(uri)
			if res.body == 'KO'
				puts "Bad arguments."
			else
				if res.body == ''
					puts "Node not found"
				else
					@farm, @datacenter, @country = res.body.strip.split(",")
					#puts "%s - %s - %s" % [@farm, @datacenter, @country]
				end
			end
		end

		def populate_files
			addfile "params/nodes/#{@fqdn}.yaml" 
			addfile "params/farm_datacenter/#{@farm}_#{@datacenter}.yaml"
			addfile "params/farm/#{@farm}.yaml"
			addfile "params/datacenter/#{@datacenter}.yaml"
			addfile "params/country/#{@country}.yaml"
		end

		def addfile(path)
			@files << path if File.exist?(path)
		end

		def classpath(path)
			File.join(Config.classespath, "#{path}.pp")
		end

		def modulepath(path)
			File.join("modules", path)
		end

		def populate_params
			params = {}
			@files.each do |f|
				data = YAML.load_file(f)
				s = to_shallow_hash(data)
				s.each do |k,v|
					params[k] ||= []
					params[k] << { value: v, file: f}
				end
			end
			params.sort
		end

		def populate_modules
			classfile = classpath(@farm)
			if File.exist?(classfile)
				@classfile = "manifests/classes/#{farm}.pp"
				modules = {}
				f = File.open(classfile, "r")
				f.each_line do |line|
					modules = add_module(line, modules)
				end
				f.close
				modules
			else
				puts "Class file #{classfile} not found."
			end
		end

		def add_modules(line, modules)
		  if /^\s*include\s*([-_:a-zA-Z0-9]*)\s*/.match line
		  	mod = $1
		  	if modules[mod] && Config.format != 'raw'
		  		modules[mod] += " (duplicate)"
		  	else
		  		if Dir.exists? modulepath(mod)
			  		modules[mod] = "modules/#{mod}"
			  	elsif Config.format != 'raw'
			  		modules[mod] = "not found."
			  	end
		  	end
		  end
		end

	end

end