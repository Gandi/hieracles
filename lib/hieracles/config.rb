require 'fileutils'

module Hieracles
  # configuration singleton
  module Config
    extend self

    attr_reader :extraparams, :server, :classpath, :modulepath, :hierafile, :format

    def load(options)
      @optionfile = options[:config] || defaultconfig
      @extraparams = extract_params(options[:params])
      initconfig(@optionfile) unless File.exist? @optionfile
      values = YAML.load_file(@optionfile)
      @server = values['server']
      @classpath = values['classpath']
      @modulepath = values['modulepath'] || 'modules'
      @hierafile = values['hierafile'] || 'hiera.yaml'
      @format = (options[:format] || values['format'] || 'console').capitalize
    end

    def initconfig(file)
      FileUtils.mkdir_p(File.dirname(file))
      File.open(file, 'w') do |f|
        f.puts '---'
        f.puts '# uncomment if you use the CGI method for discovery'
        f.puts '# server: puppetserver.example.com'
        f.puts 'classpath: manifests/classes/%s.pp'
        f.puts 'modulepath: modules'
        f.puts 'hierafile: hiera.yaml'
      end
    end

    def defaultconfig
      File.join(ENV['HOME'], '.config', 'hieracles', 'config.yml')
    end

    # str is like: something=xxx;another=yyy  
    def extract_params(str)
      return {} unless str
      str.split(';').reduce({}) do |a, k|
        a["#{k[/^[^=]*/]}"] = k[/[^=]*$/]
        a
      end
    end

  end
end
