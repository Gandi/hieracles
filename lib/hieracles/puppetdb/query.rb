module Hieracles
  module Puppetdb
    class Query

      def initialize(elements)
        @elements = parse(elements)
      end

      def parse(elements)
        items = []
        index = 0
        @elements.each do |e|
          if e == 'or'
            index++
            continue
          end
          if /(.*)(>|<|=|!=|~)(.)/.match e
            items[index] ||= []
            items[index] << [$2, $1, $3]
          end
        end
        items
      end

      def defined?
        @elements.count > 0
      end

      def match(item)
        @elements.each do |e|
          matched = false
          e.each do |a|
            case a[0]
            when '='

            when '!='
            when '<'
            when '>'
            when '!'
            else
            end
          end
          return true if matched
        end
      end

    end
  end
end
