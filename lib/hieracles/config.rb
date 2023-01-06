require 'fileutils'
require 'json'
require 'yaml'
require 'hieracles/utils'

module Hieracles
  class Config
    include Hieracles::Utils

    attr_reader :extraparams, :server, :classpath, :scope, :puppetdb, :usedb,
      :modulepath, :hierafile, :basepath, :encpath, :format, :interactive

    def initialize(options)
      @options = options
      @optionfile = @options[:config] || defaultconfig
      @extraparams = extract_params(options[:params])
      @values = get_config(@optionfile)
      @server = @values['server']
      @usedb = if @options[:db]
        true
      elsif @options[:nodb]
        false
      else
        @values['usedb']
      end
      @puppetdb = @values['puppetdb']
      @values['basepath'] ||= @values['localpath']
      @basepath = File.expand_path(pick_first(:basepath, '.'))
      @classpath = build_path(@values['classpath'])
      @modulepath = resolve_path(pick_first(:modulepath, 'modules'))
      @encpath = resolve_path(pick_first(:encpath, 'enc'))
      @hierafile = resolve_path(pick_first(:hierafile, 'hiera.yaml'))
      @format = pick_first(:format, 'console').capitalize
      @scope = load_scope(@values)
      @interactive = pick_first(:interactive, false)
    end

    def pick_first(label, default)
      @options[label] || @values[label.to_s] || default
    end

    def get_config(file)
      initconfig(file) unless File.exist? file
      YAML.load_file(file)
    end

    def initconfig(file)
      FileUtils.mkdir_p(File.dirname(file))
      File.open(file, 'w') do |f|
        f.puts '---'
        f.puts 'classpath: manifests/classes/%s.pp'
        f.puts 'modulepath: modules'
        f.puts 'encpath: enc'
        f.puts 'hierafile: hiera.yaml'
      end
    end

    def defaultconfig
      File.join(ENV['HOME'], '.config', 'hieracles', 'config.yml')
    end

    # str is like: something=xxx;another=yyy  
    def extract_params(str)
      return {} unless str
      str.split(',').reduce({}) do |a, k|
        a["#{k[/^[^=]*/]}".to_sym] = k[/[^=]*$/]
        a
      end
    end

    def load_scope(values)
      facts_file = @options[:yaml_facts] || @options[:json_facts]
      facts_format = @options[:json_facts] ? :json : :yaml
      sym_keys((facts_file && load_facts(facts_file, facts_format)) || values['defaultscope'] || {})
    end

    def load_facts(file, format)
      if format == :json
        JSON.parse(File.read(file))
      else
        YAML.load_file(file)
      end
    end

    def resolve_path(path)
      if File.exist?(File.expand_path(path))
        File.expand_path(path)
      elsif File.exist?(File.expand_path(File.join(@basepath, path)))
        File.expand_path(File.join(@basepath, path))
      else
        raise IOError, "File #{path} not found."
      end
    end

    def build_path(path)
      File.expand_path(File.join(@basepath, path))
    end

  end
end
