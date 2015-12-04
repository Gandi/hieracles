module Hieracles
  module Formats
    # for db compatibility
    class Csv < Hieracles::Format
      CVS_DELIM = ';'

      def info(_)
        make_csv @node.info.values
      end

      def facts(_)
        make_csv(@node.facts.keys) + make_csv(@node.facts.values)
      end

      def files(_)
        make_csv @node.files
      end

      def paths(_)
        make_csv @node.paths
      end

      def build_head(without_common)
        output = []
        @node.files(without_common).each do |f|
          output << f
        end
        output += %w(var value overriden)
        make_csv output
      end

      def build_params_line(key, value, filter)
        output = ''
        if !filter || Regexp.new(filter).match(key)
          first = value.pop
          if is_merged? first
            output << build_line('-', key, first[:merged])
            output << build_line(first[:file], key, first[:value], '1')
          else
            output << build_line(first[:file], key, first[:value])
          end
          while value.count > 0
            overriden = value.pop
            output << build_line(overriden[:file], key, overriden[:value], '1')
          end
        end
        output
      end

      def build_modules_line(key, value)
        make_csv [key, value]
      end

    private

      def build_line(whatfile, key, value, overriden = '0')
        make_csv(in_what_file(whatfile) + [key, value.to_s, overriden])
      end

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
