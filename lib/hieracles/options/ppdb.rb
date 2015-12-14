require 'hieracles/optparse'

module Hieracles
  module Options
    class Ppdb < Hieracles::Optparse

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

Usage: ppdb<command> [extra_args]

Available commands:
  node info <fqdn>
  node facts <fqdn>
  node resources <fqdn>
  factnames
  facts <name> <value>
  same <name> <fqdn>

        END
      end

    end
  end
end
    
