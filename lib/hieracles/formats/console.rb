module Hieracles
  module Formats
    # format accepting colors
    # for display in the terminal
    class Console < Hieracles::Dispatch
      COLORS = [
        "\e[31m%s\e[0m",
        "\e[32m%s\e[0m",
        "\e[33m%s\e[0m",
        "\e[34m%s\e[0m",
        "\e[35m%s\e[0m",
        "\e[36m%s\e[0m",
        "\e[37m%s\e[0m",
        "\e[38m%s\e[0m",
        "\e[97m%s\e[0m"
      ]

      def info(_)
        back = format('Node:       %s', @node.fqdn)
        back << format('farm:       %s', @node.farm)
        back << format('datacenter: %s', @node.datacenter)
        back << format('country:    %s', @node.country)
        back
      end

      def files(_)
        @node.files
      end

      def paths(_)
        @node.paths
      end

      def params(args)
        @colors = {}
        super
      end

      def build_head
        output = ''
        @node.files.each_with_index do |f, i|
          output << format("#{color(i)}\n", "[#{i}] #{f}")
          @colors[f] = i
        end
        "#{output}\n"
      end

      def build_params_line(key, value, filter)
        output = ''
        if !filter || Regexp.new(filter).match(k)
          first = value.shift
          filecolor_index = @colors[first[:file]]
          filecolor = color(filecolor_index)
          output << format("#{filecolor} #{color(5)} ",
                           ["[#{filecolor_index}]", key])
          output << "#{first[:value].to_s.gsub('%', '%%')}\n"
          while value.count > 0
            overriden = value.shift
            filecolor_index = @colors[overriden[:file]]
            output << format("    #{color(8)}\n",
                             ["[#{filecolor_index}] #{k} #{overriden[:value]}"])
          end
        end
        output
      end

      def build_modules_list(key, value)
        length = @node.modules.keys.reduce(0) do |a, x|
          (x.length > a) ? x.length : a
        end + 3
        val = '%s'
        val = color(0) if /not found/i.match value
        val = color(2) if /\(duplicate\)/i.match value
        format("%-#{length}s #{val}\n", [key, value])
      end

      def color(c)
        if Config.colors
          COLORS[c]
        else
          '%s'
        end
      end
    end
  end
end
