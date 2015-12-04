module Hieracles
  module Puppetdb
    class Request

      def initialize(client)
        @client = client
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
