module Hieracles
  module Puppetdb
    class Response
      attr_reader :data, :total_records, :notifications

      def initialize(data, total_records = nil, notifications = nil)
        @data = data
        @total_records = total_records
        @notifications = notifications
      end
    end
  end
end
