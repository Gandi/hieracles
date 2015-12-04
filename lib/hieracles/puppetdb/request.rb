module Hieracles
  module Puppetdb
    class Request

      def initialize(options)
        @client = Hieracles::Puppetdb::Client.new options
      end

      def node_info(fqdn)
        @client.request "nodes/#{fqdn}"
      end

      def node_facts(fqdn)
        @client.request "nodes/#{fqdn}/facts"
      end

    end
  end
end
