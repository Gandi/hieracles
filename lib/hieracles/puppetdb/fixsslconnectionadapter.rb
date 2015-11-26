require 'httparty'

module Hieracles
  module Puppetdb
    class FixSSLConnectionAdapter < HTTParty::ConnectionAdapter
      def attach_ssl_certificates(http, options)
        http.cert    = OpenSSL::X509::Certificate.new(File.read(options['cert']))
        http.key     = OpenSSL::PKey::RSA.new(File.read(options['key']), options['key+password'])
        http.ca_file = options['ca_file']
        if options['verify_peer']
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        else
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end
    end
  end
end
