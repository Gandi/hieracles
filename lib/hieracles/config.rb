require 'fileutils'

module Hieracles
  # configuration singleton
  module Config
    extend self

    attr_reader :server, :classpath, :modulepath, :format

    def load(options)
      @optionfile = options[:config] || defaultconfig
      initconfig(@optionfile) unless File.exist? @optionfile
      values = YAML.load_file(@optionfile)
      @server = values['server']
      @classpath = values['classpath']
      @modulepath = values['modulepath']
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
      end
    end

    def defaultconfig
      File.join(ENV['HOME'], '.config', 'hieracles', 'config.yml')
    end
  end
end
