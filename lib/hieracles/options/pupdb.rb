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

      def self.usage
        return <<-END

Usage: pupdb <endpoint> <command> [extra_args]

Available commands:
  node info <fqdn>
  node facts <fqdn>
  node resources <fqdn>

        END
      end

    end
  end
end
    
