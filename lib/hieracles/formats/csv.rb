module Hieracles
  module Formats

    class Csv < Hieracles::Dispatch

      CVS_DELIM = ";"

      def info(*args)
        puts [ @node.fqdn, @node.farm, @node.datacenter, @node.country ].join(',')
      end

      def files(*args)
        puts @node.files.join(',')
      end

      def paths(*args)
        puts @node.paths.join(',')
      end

      def show_head
        output = []
        @node.files.each do |f|
          output << f
        end
        output << "var"
        output << "value"
        output << "overriden"
        output.join(CVS_DELIM) + "\n"
      end

      def show_params(key, value, filter)
        output = []
        if !filter || Regexp.new(filter).match(k)
          first = value.shift
          begin
            output = in_what_file(first[:file])
            output << key
            output << first[:value].to_s
            output << "0"
          end
          while value.count > 0
            overriden = value.shift
            output = in_what_file(overriden[:file])
            output << key
            output << first[:value].to_s
            output << "1"
          end
        end
        output.join(CVS_DELIM) + "\n"
      end

      def in_what_file(file)
        output = []
        @node.files.each do |f|
          if file == f
            output << "1"
          else
            output << "0"
          end
        end
        output
      end

    end

  end
end
