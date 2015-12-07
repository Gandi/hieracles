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

      def node_resources(fqdn)
        @client.request "nodes/#{fqdn}/resources"
      end
      alias_method :node_res, :node_resources

    end
  end
end
