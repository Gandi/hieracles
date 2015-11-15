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
      },
      basepath: {
        has_arg: true,
        aliases: ['b', 'basepath']
      },
      encpath: {
        has_arg: true,
        aliases: ['e', 'encpath']
      },
      version: {
        has_arg: false,
        aliases: ['v', 'version']
      },
      yaml_facts: {
        has_arg: true,
        aliases: ['y', 'yaml']
      },
      json_facts: {
        has_arg: true,
        aliases: ['j', 'json']
      },
      interactive: {
        has_arg: false,
        aliases: ['i', 'interactive']
      }
    }

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
      OPTIONS.each do |k, v|
        v[:aliases].each do |a|
          back[a] = { var: k, has_args: v[:has_arg] }
        end
      end
      back
    end

  end

end
