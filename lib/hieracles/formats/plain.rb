module Hieracles
  module Formats
    # format accepting colors
    # for display in the terminal
    class Plain < Hieracles::Format
      include Hieracles::Utils

      def initialize(node)
        @index = {}
        super(node)
      end

      def info(_)
        back = ''
        length = max_key_length(@node.info) + 2
        @node.info.each do |k, v|
          back << format("%-#{length}s %s\n", k, v)
        end
        back
      end

      def files(_)
        @node.files.join("\n") + "\n"
      end

      def paths(_)
        @node.paths.join("\n") + "\n"
      end

      def build_head(without_common)
        output = "[-] (merged)\n"
        @node.files(without_common).each_with_index do |f, i|
          output << "[#{i}] #{f}\n"
          @index[f] = i
        end
        "#{output}\n"
      end

      def build_params_line(key, value, filter)
        output = ''
        if !filter || Regexp.new(filter).match(key)
          first = value.pop
          filecolor_index = @index[first[:file]]
          if first[:value].is_a?(Array) &&
            (first[:value] | first[:merged]) != first[:value]
            output << "[-] #{key} #{first[:merged]}\n"
            output << "    [#{filecolor_index}] #{key} #{first[:value]}\n"
          else
            output << "[#{filecolor_index}] #{key} #{first[:value]}\n"
          end
          while value.count > 0
            overriden = value.pop
            filecolor_index = @index[overriden[:file]]
            output << "    [#{filecolor_index}] #{key} #{overriden[:value]}\n"
          end
        end
        output
      end

      def build_modules_line(key, value)
        length = max_key_length(@node.modules) + 3
        format("%-#{length}s %s\n", key, value)
      end

    end
  end
end
