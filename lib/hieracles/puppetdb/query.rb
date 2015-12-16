module Hieracles
  module Puppetdb
    class Query

      attr_reader :elements

      def initialize(elements)
        @elements = parse(elements)
      end

      def parse(elements)
        if number_or(elements) > 0
          elements = build_or(elements)
        end
        build_and elements
      end

      def build_and(arrays)
        back = arrays.reduce([]) do |a, v|
          if v.class.name == 'Array'
            if v.length > 1
              a << ['and'] + v.map { |e| expression(e) }
            else
              e = expression(v[0])
              a << e if e
            end
          elsif v == 'or'
            a << 'or'
          else
            e = expression(v)
            a << e if e
          end
          a
        end
        if back.length == 1 and back[0].class.name == 'Array'
          back = back[0]
        elsif back[0].class.name == 'Array' and back.length > 1
          back.unshift('and')
        end
        back
      end

      def build_or(arrays)
        back = ['or']
        (0..number_or(arrays)-1).each do |a|
          back << arrays.slice!(0..arrays.index('or')-1)
          arrays.shift
        end
        back << arrays
      end

      def expression(e)
        if /([^!]*)(!)?(>|<|=|~)(.*)/.match e
          if $2
            ['not', [$3, $1, $4]]
          else
            [$3, $1, $4]
          end
        end
      end

      def number_or(a)
        a.select { |i| i == 'or' }.length
      end

    end
  end
end
