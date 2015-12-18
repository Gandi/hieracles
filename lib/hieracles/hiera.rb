module Hieracles
  class Hiera

    def initialize(config)
      @config = config
      raise IOError, "Hierafile #{@config.hierafile} not found." unless File.exist? @config.hierafile
      @hierafile = @config.hierafile
      @loaded = YAML.load_file(@hierafile)
    end

    def datapath
      raise TypeError, "Sorry hieracles only knows yaml backend for now." unless @loaded[:yaml]
      parampath = File.expand_path(File.join(@config.basepath, datadir))
      raise IOError, "Params dir #{parampath} not found." unless Dir.exist? parampath
      parampath
    end

    def hierarchy
      @loaded[:hierarchy]
    end

    def datadir
      @loaded[:yaml][:datadir]
    end

    def params
      hierarchy.join(',').scan(/%\{(?:::)?([^\}]*)\}/).flatten.uniq
    end

    def merge_behavior
      case @loaded[:merge_behavior]
      when :deep,'deep',:deeper,'deeper'
        @loaded[:merge_behavior].to_sym
      else
        :native
      end
    end

  end
end
