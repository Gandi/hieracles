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
        make_hashed resp
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

      def factnames()
        @client.request("fact-names")
      end

      def resources(*args)
        query = Query.new args
        make_hashed @client.request("resources", query.elements)
      end
      alias_method :res, :resources

      def events
        @client.request("events")
      end

    private

      def extract_names(resp, label = 'certname')
        resp.data = resp.data.reduce([]) do |a, d|
          a << d[label]
          a
        end.sort
        resp
      end

      def make_hashed(resp, label = 'title', filter = nil)
        resp.data = resp.data.reduce({}) do |a, d|
          if !filter || Regexp.new(filter).match(d[label])
            a[d[label]] = d
          end
          a
        end
        resp
      end

    end
  end
end
