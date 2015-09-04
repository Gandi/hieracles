module Hieracles
  module Formats
    # format accepting colors
    # for display in the terminal
    class Plain < Hieracles::Format

      def initialize(node)
        @index = {}
        super(node)
      end

      def info(_)
        back =  format("Node:       %s\n", @node.fqdn)
        back << format("Farm:       %s\n", @node.farm)
        back << format("Datacenter: %s\n", @node.datacenter)
        back << format("Country:    %s\n", @node.country)
        back
      end

      def files(_)
        @node.files.join("\n") + "\n"
      end

      def paths(_)
        @node.paths.join("\n") + "\n"
      end

      def build_head
        output = ''
        @node.files.each_with_index do |f, i|
          output << "[#{i}] #{f}\n"
          @index[f] = i
        end
        "#{output}\n"
      end

      def build_params_line(key, value, filter)
        output = ''
        if !filter || Regexp.new(filter).match(k)
          first = value.shift
          filecolor_index = @index[first[:file]]
          output << "[#{filecolor_index}] #{key} #{first[:value]}\n"
          while value.count > 0
            overriden = value.shift
            filecolor_index = @index[overriden[:file]]
            output << "  [#{filecolor_index}] #{key} #{overriden[:value]}\n"
          end
        end
        output
      end

      def build_modules_line(key, value)
        length = @node.modules.keys.reduce(0) do |a, x|
          (x.length > a) ? x.length : a
        end + 3
        format("%-#{length}s %s\n", [key, val])
      end

    end
  end
end
