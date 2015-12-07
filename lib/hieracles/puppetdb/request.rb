module Hieracles
  module Puppetdb
    class Request

      def initialize(options)
        @client = Hieracles::Puppetdb::Client.new options
      end

      def node_info(fqdn)
        @client.request("nodes/#{fqdn}")
      end
      alias_method :node_infos, :node_info

      def node_facts(fqdn)
        resp = @client.request("nodes/#{fqdn}/facts")
        resp.data = resp.data.reduce({}) do |a, d|
          a[d['name'].to_sym] = d['value']
          a
        end
        resp
      end
      alias_method :node_fact, :node_facts

      def node_resources(fqdn)
        resp = @client.request "nodes/#{fqdn}/resources"
        resp.data = resp.data.reduce({})  do |a, d|
          a[d['title']] = d
          a
        end
        resp
      end
      alias_method :node_res, :node_resources

    end
  end
end
