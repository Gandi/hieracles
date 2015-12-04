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

    end
  end
end
    
