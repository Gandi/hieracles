module Hieracles

  class Hiera

    def initialize(hierafile)
      raise IOError, "Hierafile #{hierafile} not found." unless File.exist? hierafile
      @hierafile = hierafile
      @loaded = YAML.load_file(hierafile)
    end

    def datadir
      raise TypeError, "Sorry hieracles only knows yaml backend for now." unless @loaded[:yaml]
      parampath = File.expand_path(File.join('..', @loaded[:yaml][:datadir]), @hierafile)
      raise IOError, "Params dir not found." unless Dir.exist? parampath
      parampath
    end

  end
end
