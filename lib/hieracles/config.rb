require 'fileutils'

module Hieracles

  module Config
    extend self

    attr_reader :server, :classespath, :format, :colors

    def load(options)
      @optionfile = options['c'] || File.join(ENV['HOME'], '.config', 'hieracles', 'config.yml')
      @format = (options['f'] || 'console').capitalize
      self.initconfig(@optionfile) unless File.exist? @optionfile
      values = YAML.load_file(@optionfile)
      @colors = values['colors']
      @server = values['server']
      @classespath = File.join('manifests', 'classes')
    end

    def initconfig(file)
      FileUtils.mkdir_p(File.dirname(file))
      File.open(file,'w') do |f|
        f.puts '---'
        f.puts '# uncomment if you use the CGI method for discovery'
        f.puts '# server: puppetserver.exmaple.com'
        f.puts 'colors: true'
      end
    end

  end

end
