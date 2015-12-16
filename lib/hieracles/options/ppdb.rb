require 'hieracles/optparse'

module Hieracles
  module Options
    class Ppdb < Hieracles::Optparse

      def available_options
        {
          version: {
            has_arg: false,
            aliases: ['v', 'version']
          },
          format: {
            has_arg: true,
            aliases: ['f', 'format']
          }
        }
      end

      def self.usage
        return <<-END

Usage: ppdb <command> [extra_args]

Available commands:
  node info <fqdn>
  node facts <fqdn>
  node resources <fqdn>
  facts <name> <value>
  same <name> <fqdn>
  factnames
  res[ources] <query>
              query following the form:
              type=sometype title=what
              type=sometype or type=another
              type~someregexp type!~excluded
        END
      end

    end
  end
end
    
