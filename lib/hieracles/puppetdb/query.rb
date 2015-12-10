module Hieracles
  module Puppetdb
    class Query

      def initialize(elements)
        @elements = parse(elements)
      end

      def parse(elements)
        items = []
        index = 0
        if elements.length > 1
          elements.each do |e|
            puts items.inspect
            if e == 'or'
              index++
              continue
            end
            if /(.*)(>|<|=|!=|~)(.*)/.match e
              items[index] ||= []
              items[index] << [$2, $1, $3]
            end
          end
        else
          if /(.*)(>|<|=|!=|~)(.*)/.match elements[0]
            items = [$2, $1, $3]
          end
        end
        items
      end

      def output
        back = []
        if @elements.length > 1
          back << 'or' 
          @elements.each do |e|
            back << build_and(e)
          end
        else
          @elements.each do |e|
            back << build_and(e)
          end
        end
        back
      end

      def build_and(arrays)
        if arrays.length > 1
          ['and', arrays]
        else
          arrays
        end
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
