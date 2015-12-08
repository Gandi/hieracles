module Hieracles
  module Puppetdb
    class Filter

      def initialize(regexp)
        @regexp = Regexp.new(regexp)
      end

      def match(something)
        @regexp.match something
      end

    end
  end
end
