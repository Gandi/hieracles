module Hieracles
  module Formats
    # for db compatibility
    class Csv < Hieracles::Format
      CVS_DELIM = ';'

      def info(_)
        make_csv @node.info.values
      end

      def files(_)
        make_csv @node.files
      end

      def paths(_)
        make_csv @node.paths
      end

      def build_head
        output = []
        @node.files.each do |f|
          output << f
        end
        output += %w(var value overriden)
        make_csv output
      end

      def build_params_line(key, value, filter)
        output = ''
        if !filter || Regexp.new(filter).match(key)
          first = value.shift
          output << make_csv(in_what_file(first[:file]) +
                   [key, first[:value].to_s, '0'])
          while value.count > 0
            overriden = value.shift
            output << make_csv(in_what_file(overriden[:file]) +
                     [key, overriden[:value].to_s, '1'])
          end
        end
        output
      end

      def build_modules_line(key, value)
        make_csv [key, value]
      end

    private

      def make_csv(array)
        array.join(CVS_DELIM) + "\n"
      end

      def in_what_file(file)
        output = []
        @node.files.each do |f|
          if file == f
            output << '1'
          else
            output << '0'
          end
        end
        output
      end
    end
  end
end
