module Hieracles
  module Formats
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

      def info(*args)
        puts "Node:       %s" % @node.fqdn
        puts "farm:       %s" % @node.farm
        puts "datacenter: %s" % @node.datacenter
        puts "country:    %s" % @node.country
      end

      def files(*args)
        puts @node.files
      end

      def paths(*args)
        puts @node.paths
      end

      def params(args)
        @colors = {}
        super
      end

      def build_head
        output = ""
        @node.files.each_with_index do |f,i|
          output << "#{color(i)}\n" % "[#{i}] #{f}"
          @colors[f] = i
        end
        "#{output}\n"
      end

      def build_params_line(key, value, filter)
        output = ""
        if !filter || Regexp.new(filter).match(k)
          first = value.shift
          filecolor_index = @colors[first[:file]]
          filecolor = color(filecolor_index)
          output << "#{color(filecolor_index)} #{color(5)} " % 
                    ["[#{filecolor_index}]", key]
          output << "#{first[:value].to_s.gsub('%', '%%')}\n"
          while value.count > 0
            overriden = value.shift
            filecolor_index = @colors[overriden[:file]]
            output << "    #{color(8)}\n" % 
                      ["[#{filecolor_index}] #{k} #{overriden[:value]}"]
          end
        end
        output
      end

      def build_modules_list(key, value)
        length = @node.modules.keys.reduce(0) do |a, x| 
            (x.length > a) ? x.length : a 
          end + 3
        val = "%s"
        val = color(0) if /not found/i.match value
        val = color(2) if /\(duplicate\)/i.match value
        "%-#{length}s #{val}\n" % [key, value]
      end

      def color(c)
        if Config.colors
          COLORS[c]
        else
          "%s"
        end
      end

    end
  end
end
