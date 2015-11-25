module Hieracles
  module Puppetdb
    class APIError < Exception
      attr_reader :code, :response
      def initialize(response)
        @response = response
      end
    end
  end
end
