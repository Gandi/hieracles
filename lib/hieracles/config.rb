require 'fileutils'

module Hieracles
  module Config
    module_function

    attr_reader :server, :classpath, :format, :colors

    def load(options)
      @optionfile = options['c'] || defaultconfig
      initconfig(@optionfile) unless File.exist? @optionfile
      values = YAML.load_file(@optionfile)
      @colors = values['colors']
      @server = values['server']
      @classpath = values['classpath']
      @format = (options['f'] || values['format'] || 'console').capitalize
    end

    def initconfig(file)
      FileUtils.mkdir_p(File.dirname(file))
      File.open(file, 'w') do |f|
        f.puts '---'
        f.puts '# uncomment if you use the CGI method for discovery'
        f.puts '# server: puppetserver.example.com'
        f.puts 'colors: true'
        f.puts 'classpath: manifests/classes/%s.pp'
      end
    end

    def defaultconfig
      File.join(ENV['HOME'], '.config', 'hieracles', 'config.yml')
    end
  end
end
