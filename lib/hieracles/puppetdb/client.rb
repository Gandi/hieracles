require 'httparty'

module Hieracles
  module Puppetdb
    class Client
      include HTTParty
 
      def initialize(options, version = 3)
        @version = version
        setup_if_ssl(options)
        options['port'] ||= 8080
        options['host'] ||= 'localhost'
        scheme = options['usessl'] ? "https://" : "http://"
        self.class.base_uri(scheme + 
          options['host'] +
          ':' + options['port'].to_s +
          '/v' + @version.to_s())
      end

      def setup_if_ssl(options)
        if options['usessl']
          self.class.default_options = {:options => options}
          self.class.connection_adapter(FixSSLConnectionAdapter)
        end
      end

      def request(endpoint, method = 'get', query = nil, opts = {})
        ret = send("#{method}_request".to_sym, endpoint, query, opts)
        if ret.code.to_s() =~ /^[4|5]/ or ret.parsed_response.length < 1
          notifications = [ Hieracles::Notification.new('puppetdb', 'No match.', 'error') ]
          Response.new({}, 0, notifications)
        else
          total = ret.headers['X-Records']
          if total.nil?
            total = ret.parsed_response.length
          end

          Response.new(ret.parsed_response, total)
        end
      end

      def get_request(endpoint, query, opts)
        path = "/" + endpoint
        if query
          json_query = JSON.dump(query)
          filtered_opts = {'query' => json_query}
          opts.each do |k,v|
            if k == :counts_filter
              filtered_opts['counts-filter'] = JSON.dump(v)
            else
              filtered_opts[k.to_s.sub("_", "-")] = v
            end
          end
          puts path ; puts filtered_opts ; exit(0)
          self.class.get(path, query: filtered_opts)
        else
          self.class.get(path)
        end
      end

    end
  end
end
