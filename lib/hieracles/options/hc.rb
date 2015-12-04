module Hieracles
  module Options
    class Hc < Hieracles::Optparse

      def available_options
        {
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
          },
          db: {
            has_arg: false,
            aliases: ['db']
          },
          nodb: {
            has_arg: false,
            aliases: ['nodb', 'no-db', 'no']
          }
        }
      end

    end
  end
end
    
