module Hieracles
  module Formats

    class Csv < Hieracles::Dispatch

      CVS_DELIM = ";"

      def info(*args)
        [ @node.fqdn, @node.farm, @node.datacenter, @node.country ].join(',')
      end

      def files(*args)
        @node.files.join(',')
      end

      def paths(*args)
        @node.paths.join(',')
      end

      def build_head
        output = []
        @node.files.each do |f|
          output << f
        end
        output += %w(var value overriden)
        output.join(CVS_DELIM) + "\n"
      end

      def build_params_line(key, value, filter)
        output = []
        if !filter || Regexp.new(filter).match(k)
          first = value.shift
          begin
            output = in_what_file(first[:file])
            output += [ key, first[:value].to_s, "0" ]
          end
          while value.count > 0
            overriden = value.shift
            output = in_what_file(overriden[:file])
            output += [ key, first[:value].to_s, "1" ]
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
