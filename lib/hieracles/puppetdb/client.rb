require 'httparty'

module Hieracles
  module Puppetdb
    class Client
      include HTTParty
      attr_reader :use_ssl
      attr_writer :logger

      def hash_get(hash, key)
        untouched = hash[key]
        return untouched if untouched

        sym = hash[key.to_sym()]
        return sym if sym

        str = hash[key.to_s()]
        return str if str

        nil
      end

      def hash_includes?(hash, *sought_keys)
        sought_keys.each {|x| return false unless hash.include?(x)}
        true
      end

      def debug(msg)
        if @logger
          @logger.debug(msg)
        end
      end

      def initialize(settings, version=3)
        @version = version

        server = hash_get(settings, 'server')
        pem    = hash_get(settings, 'pem')

        scheme = URI.parse(server).scheme

        unless ['http', 'https'].include? scheme
          error_msg = "Configuration error: :server must specify a protocol of either http or https"
          raise error_msg
        end

        @use_ssl = scheme == 'https'
        if @use_ssl
          unless pem && hash_includes?(pem, 'key', 'cert', 'ca_file')
            error_msg = 'Configuration error: https:// specified but pem is missing or incomplete. It requires cert, key, and ca_file.'
            raise error_msg
          end

          self.class.default_options = {:pem => pem}
          self.class.connection_adapter(FixSSLConnectionAdapter)
        end

        self.class.base_uri(server + '/v' + version.to_s())
      end

      def raise_if_error(response)
        if response.code.to_s() =~ /^[4|5]/
          raise APIError.new(response)
        end
      end

      def request(endpoint, query, opts={})
        query = Query.maybe_promote(query)
        json_query = query.build()

        path = "/" + endpoint

        filtered_opts = {'query' => json_query}
        opts.each do |k,v|
          if k == :counts_filter
            filtered_opts['counts-filter'] = JSON.dump(v)
          else
            filtered_opts[k.to_s.sub("_", "-")] = v
          end
        end

        debug("#{path} #{json_query} #{opts}")

        ret = self.class.get(path, :query => filtered_opts)
        raise_if_error(ret)

        total = ret.headers['X-Records']
        if total.nil?
          total = ret.parsed_response.length
        end

        Response.new(ret.parsed_response, total)
      end
    end
  end
end
