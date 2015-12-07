require 'hieracles/optparse'

module Hieracles
  module Options
    class Pupdb < Hieracles::Optparse

      def available_options
        {
          version: {
            has_arg: false,
            aliases: ['v', 'version']
          }
        }
      end

      def usage
        return <<-END

        Usage: pupdb <command> [extra_args]

        Available commands:

        ... wip ...
        
        END
      end

    end
  end
end
    
