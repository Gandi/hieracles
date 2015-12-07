require 'httparty'

module Hieracles
  module Puppetdb
    class FixSSLConnectionAdapter < HTTParty::ConnectionAdapter
      def attach_ssl_certificates(http, options)
        raise(IOError, "Cert file #{options['cert']} not found.") unless File.exist? options['cert'].to_s
        raise(IOError, "Key file #{options['key']} not found.") unless File.exist? options['key']
        raise(IOError, "CA file #{options['ca_file']} not found.") unless File.exist? options['ca_file']
        http.cert = OpenSSL::X509::Certificate.new(File.read(options['cert']))
        if options['key_password']
          http.key = OpenSSL::PKey::RSA.new(File.read(options['key']), options['key_password'])
        else
          http.key = OpenSSL::PKey::RSA.new(File.read(options['key']))
        end
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
