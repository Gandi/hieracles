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

      def info(filter)
        build_list(@node.info, @node.notifications, filter)
      end

      def facts(filter)
        build_list(@node.facts, @node.notifications, filter)
      end

      def build_list(hash, notifications, filter)
        back = ''
        back << build_notifications(notifications) if notifications
        if filter[0]
          hash.select! { |k, v| Regexp.new(filter[0]).match(k) }
        end
        length = max_key_length(hash) + 2
        hash.each do |k, v|
          back << format("%-#{length}s %s\n", k, v)
        end
        back
      end

      def build_notifications(notifications)
        back = "\n"
        notifications.each do |v|
          back << "*** #{v.source}: #{v.message} ***\n"
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
          output << "[#{i}] #{f}\n"
          @index[f] = i
        end
        "#{output}\n"
      end

      def build_params_line(key, value, filter)
        output = ''
        if !filter || Regexp.new(filter).match(key)
          output << build_line_item(key, value)
        end
        output
      end

      def build_line_item(key, value)
        if value[:overriden]
          "[-] #{key} #{value[:value]}\n" +
          build_overriden(key, value[:found_in])
        else
          filecolor_index = @index[value[:file]]
          output << "[#{filecolor_index}] #{key} #{value[:value]}\n"
        end
      end

      def build_overriden(key, found_in)
        back = ''
        found_in.each do |v|
          filecolor_index = @index[v[:file]]
          back << "    [#{filecolor_index}] #{key} #{v[:value]}\n"
        end
        back
      end


      def build_modules_line(key, value)
        length = max_key_length(@node.modules) + 3
        format("%-#{length}s %s\n", key, value)
      end

    end
  end
end
