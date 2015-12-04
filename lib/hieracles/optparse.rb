module Hieracles

  class Optparse
    
    attr_reader :options, :payload

    def available_options
      {}
    end

    def initialize(array)
      @options = {}
      @payload = []
      ok = optionkeys
      while x = array.shift
        if x[0] == '-'
          found = ok[x[/[a-z][-_a-z]*$/]]
          if found
            if found[:has_args]
              @options[found[:var]] = array.shift
            else
              @options[found[:var]] = true
            end
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
      available_options.each do |k, v|
        v[:aliases].each do |a|
          back[a] = { var: k, has_args: v[:has_arg] }
        end
      end
      back
    end

  end

end
