require 'httparty'

module Hieracles
  module Puppetdb
    class FixSSLConnectionAdapter < HTTParty::ConnectionAdapter
      def attach_ssl_certificates(http, options)
        raise IOError, "Cert file #{options['cert_file']} not found." unless File.exist? options['cert_file']
        raise IOError, "Key file #{options['key_file']} not found." unless File.exist? options['key_file']
        raise IOError, "CA file #{options['ca_file']} not found." unless File.exist? options['ca_file']
        http.cert = OpenSSL::X509::Certificate.new(File.read(options['cert_file']))
        if options['key+password']
          http.key = OpenSSL::PKey::RSA.new(File.read(options['key_file']), options['key+password'])
        else
          http.key = OpenSSL::PKey::RSA.new(File.read(options['key_file']))
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
