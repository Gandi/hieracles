module Hieracles
  module Puppetdb
    class Request

      def initialize(options)
        @client = Hieracles::Puppetdb::Client.new options
      end

      def info(fqdn)
        @client.request "nodes/#{fqdn}"
      end

      def facts(fqdn)
        @client.request "nodes/#{fqdn}/facts"
      end

    end
  end
end
