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

      def node_facts(fqdn, regex = //)
        resp = @client.request("nodes/#{fqdn}/facts")
        filter = Filter.new regex
        resp.data = resp.data.reduce({}) do |a, d|
          if filter.match(d['name'])
            a[d['name'].to_sym] = d['value']
          end
          a
        end
        resp
      end
      alias_method :node_fact, :node_facts

      def node_resources(fqdn, *args)
        resp = @client.request("nodes/#{fqdn}/resources")
        field = args.shift
        resp.data = resp.data.reduce({})  do |a, d|
          if !field || Regexp.new(field).match(d['title'])
            a[d['title']] = d
          end
          a
        end
        resp
      end
      alias_method :node_res, :node_resources

      def facts(label, value)
        resp = @client.request("facts/#{label}/#{value}")
        extract_names resp
      end

      def same(name, fqdn)
        r = @client.request("nodes/#{fqdn}/facts/#{name}")
        if r.data.length > 0
          value = r.data[0]['value']
          facts name, value
        else
          r
        end
      end


    private

      def extract_names(resp)
        resp.data = resp.data.reduce([])  do |a, d|
          a << d['certname']
          a
        end.sort
        resp
      end

    end
  end
end
