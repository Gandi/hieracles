module Hieracles

  class Optparse
    
    attr_reader :options, :payload

    OPTIONS = {
      config: {
        has_arg: true,
        aliases: ['c', 'conf', 'config']
      },
      format: {
        has_arg: true,
        aliases: ['f', 'format']
      },
      params: {
        has_arg: true,
        aliases: ['p', 'params']
      },
      hierafile: {
        has_arg: true,
        aliases: ['h', 'hierafile']
      }
    }

    def initialize(array)
      @options = {}
      @payload = []
      ok = optionkeys
      while x = array.shift
        if x[0] == '-'
          if ok[x[/[a-z][-_a-z]*$/]]
            @options[ok[x[/[a-z][-_a-z]*$/]]] = array.shift
          else
            array.shift
          end
        else
          @payload << x
        end
      end
    end

    def optionkeys
      back = {}
      OPTIONS.each do |k, v|
        v[:aliases].each do |a|
          back[a] = k
        end
      end
      back
    end

  end

end
