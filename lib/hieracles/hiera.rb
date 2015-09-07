module Hieracles

  class Hiera

    def initialize(hierafile)
      raise IOError, "Hierafile #{hierafile} not found." unless File.exist? hierafile
      @loaded = YAML.load_file(hierafile)
    end

    def datadir
      raise TypeError, "Sorry hieracles only knows yaml backend for now." unless @loaded[:yaml]
      @loaded[:yaml][:datadir]
    end

  end
end
