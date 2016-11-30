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
          if value[:overriden]
            output << build_line('-', key, value[:value])
            value[:found_in].each do |v|
              output << build_line(v[:file], key, v[:value], '1')
            end
          else
            output << build_line(value[:file], key, value[:value])
          end
        end
        output
      end

      def build_modules_line(key, value)
        make_csv [key, value]
      end

      def build_list(hash, notifications, filter)
        if filter[0]
          hash.select! { |k, e| Regexp.new(filter[0]).match k }
        end
        hash.reduce([]) do |a, (k, v)|
          a << make_csv([k, v.join(',')])
          a
        end.join()
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
