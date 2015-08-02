module Hieracles

  class Optparse
    
    attr_reader :options, :payload

    OPTIONS = {
      config: {
        has_arg: true,
        aliases: ['c','conf']
      }
    }

    def initialize(array)
      @options = {}
      @payload = []
      while x = array.shift
        if x[0] == '-'
          if optionkeys.include? x[/[a-z][-_a-z]*$/]
            @options[x[/[a-z][-_a-z]*$/]] = array.shift
          end
        else
          @payload << x
        end
      end      
    end

    def optionkeys
      @__optionkeys ||= OPTIONS.map do |k,v|
        [k, k[:aliases]]
      end.flatten
    end

  end

end
