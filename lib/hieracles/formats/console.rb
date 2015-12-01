module Hieracles
  module Formats
    # format accepting colors
    # for display in the terminal
    class Console < Hieracles::Format
      include Hieracles::Utils

      COLORS = [
        "\e[31m%s\e[0m",
        "\e[32m%s\e[0m",
        "\e[33m%s\e[0m",
        "\e[34m%s\e[0m",
        "\e[35m%s\e[0m",
        "\e[36m%s\e[0m",
        "\e[37m%s\e[0m",
        "\e[38m%s\e[0m",
        "\e[97m%s\e[0m",
        "\e[35;1m%s\e[0m"
      ]

      def initialize(node)
        @colors = {}
        super(node)
      end

      def info(_)
        build_list(@node.info, @node.notifications)
      end

      def facts(_)
        build_list(@node.facts, @node.notifications)
      end

      def build_list(hash, notifications)
        back = ''
        back << build_notifications(notifications) if notifications
        length = max_key_length(hash) + 2
        title = format(COLORS[8], "%-#{length}s")
        hash.each do |k, v|
          back << format("#{title} %s\n", k, v)
        end
        back
      end

      def build_notifications(notifications)
        back = "\n"
        notifications.each do |v|
          back << format("#{COLORS[9]}\n", "*** #{v.source}: #{v.message} ***")
        end
        back << "\n"
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
          output << format("#{COLORS[i]}\n", "[#{i}] #{f}")
          @colors[f] = i
        end
        "#{output}\n"
      end

      def build_params_line(key, value, filter)
        output = ''
        if !filter || Regexp.new(filter).match(key)
          first = value.pop
          filecolor_index = @colors[first[:file]]
          filecolor = COLORS[filecolor_index]
          if is_merged? first
            output << format("%s #{COLORS[5]} %s\n", "[-]", key, sanitize(first[:merged]) )
            output << format("    #{COLORS[8]}\n", "[#{filecolor_index}] #{key} #{sanitize(first[:value])}" )
          else
            output << format("#{filecolor} #{COLORS[5]} %s\n", "[#{filecolor_index}]", key, sanitize(first[:value]) )
          end
          while value.count > 0
            overriden = value.pop
            filecolor_index = @colors[overriden[:file]]
            output << format("    #{COLORS[8]}\n", "[#{filecolor_index}] #{key} #{overriden[:value]}")
          end
        end
        output
      end

      def build_modules_line(key, value)
        length = max_key_length(@node.modules) + 3
        value_color = '%s'
        value_color = COLORS[0] if /not found/i.match value
        value_color = COLORS[2] if /\(duplicate\)/i.match value
        format("%-#{length}s #{value_color}\n", key, value)
      end

    end
  end
end
