require 'fileutils'

module Hieracles

  module Config
    extend self

    attr_reader :server, :localpath, :classespath, :format, :colors

    def load(options)
      @optionfile = options['c'] || File.join(ENV['HOME'], '.config', 'hieracles', 'config.yml')
      @format = (options['f'] || 'console').capitalize
      self.initconfig(@optionfile) unless File.exist? @optionfile
      values = YAML.load_file(@optionfile)
      @colors = values['colors']
      @server = values['server']
      @localpath = values['localpath']
      @classespath = File.join('manifests', 'classes')
    end

    def initconfig(file)
      FileUtils.mkdir_p(File.dirname(file))
      File.open(file,'w') do |f|
        f.puts '---'
        f.puts 'server: puppetmaster2-d.mgt.gandi.net'
        f.puts 'localpath: ../puppet27'
        f.puts 'colors: true'
      end
    end

  end

end
