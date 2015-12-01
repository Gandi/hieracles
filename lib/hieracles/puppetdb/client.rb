require 'httparty'

module Hieracles
  module Puppetdb
    class Client
      include HTTParty
 
      def initialize(options, version = 3)
        @version = version
        if options['usessl']
          %w('key', 'cert', 'ca_file').each do |k|
            if ! options.has_key? k
              raise 'Configuration error: #{k} is missing.'
            elsif ! File.exists(options[k])
              raise 'Configuration error: #{k} file not found.'
            end
          end
          self.class.default_options = {:options => options}
          self.class.connection_adapter(FixSSLConnectionAdapter)
        end
        options['port'] || 8080
        options['host'] || 'localhost'
        scheme = options['usessl'] ? "https://" : "http://"
        self.class.base_uri(scheme + 
          options['host'] +
          ':' + options['port'].to_s +
          '/v' + @version.to_s())
      end

      def request(endpoint, query = nil, opts = {})
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
          # puts path
          # puts filtered_opts
          # return
          ret = self.class.get(path, query: filtered_opts)
        else
          ret = self.class.get(path)
        end

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

    end
  end
end
