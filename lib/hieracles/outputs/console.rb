require 'awesome_print'

module Hieracles
  module Outputs
    # format accepting colors
    # for display in the terminal
    class Console
      include Hieracles::Utils

      COLORS = [
        "\e[31m%s\e[0m",
        "\e[32m%s\e[0m",
        "\e[33m%s\e[0m",
        "\e[34m%s\e[0m",
        "\e[35m%s\e[0m",
        "\e[37m%s\e[0m",
        "\e[38m%s\e[0m",
        "\e[36m%s\e[0m",
        "\e[97m%s\e[0m",
        "\e[35;1m%s\e[0m"
      ]

      def initialize()
        @colors = {}
      end

      def hash_list(headers, hash)
        back = "\n"
        if headers.count > 0
          notifications.each do |v|
            back << format("#{COLORS[9]}\n", "*** #{v.source}: #{v.message} ***")
          end
          back << "\n"
        end
        
      end

    end
  end
end
