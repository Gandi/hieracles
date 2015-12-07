require 'spec_helper'

describe Hieracles::Puppetdb::FixSSLConnectionAdapter do

  let(:uri) { URI "https://localhost" }
  let(:options) { {} }
  let(:adapter) { Hieracles::Puppetdb::FixSSLConnectionAdapter.new uri, options }
  describe '.attach_ssl_certificates' do

    context "with cert file" do
      context "not found" do
        let(:options) {
          {
            'cert' => File.expand_path('spec/files/ssl/no-cert.crt'),
            'key' => File.expand_path('spec/files/ssl/key.pem'),
            'ca_file' => File.expand_path('spec/files/ssl/ca.crt')
          }
        }
        it { expect { adapter.connection }.to raise_error(IOError, /Cert file .*no-cert.crt not found\./) }
      end
      context "badly formatted" do
        let(:options) {
          {
            'cert' => File.expand_path('spec/files/ssl/bad-cert.crt'),
            'key' => File.expand_path('spec/files/ssl/key.pem'),
            'ca_file' => File.expand_path('spec/files/ssl/ca.crt')
          }
        }
        it { expect { adapter.connection }.to raise_error(OpenSSL::X509::CertificateError) }
      end
    end

    context "with key file" do
      context "not found" do
        let(:options) {
          {
            'cert' => File.expand_path('spec/files/ssl/cert.crt'),
            'key' => File.expand_path('spec/files/ssl/no-key.pem'),
            'ca_file' => File.expand_path('spec/files/ssl/ca.crt')
          }
        }
        it { expect { adapter.connection }.to raise_error(IOError, /Key file .*no-key.pem not found\./) }
      end
      context "badly formatted" do
        let(:options) {
          {
            'cert' => File.expand_path('spec/files/ssl/cert.crt'),
            'key' => File.expand_path('spec/files/ssl/bad-key.pem'),
            'ca_file' => File.expand_path('spec/files/ssl/ca.crt')
          }
        }
        it { expect { adapter.connection }.to raise_error(OpenSSL::PKey::RSAError) }
      end
      context "with pasword" do
        context "correct" do
          let(:options) {
            {
              'cert' => File.expand_path('spec/files/ssl/cert.crt'),
              'key' => File.expand_path('spec/files/ssl/key-pass.pem'),
              'key_password' => 'good-toto',
              'ca_file' => File.expand_path('spec/files/ssl/ca.crt')
            }
          }
          it { expect { adapter.connection }.not_to raise_error }
        end
        context "incorrect" do
          let(:options) {
            {
              'cert' => File.expand_path('spec/files/ssl/cert.crt'),
              'key' => File.expand_path('spec/files/ssl/key-pass.pem'),
              'key_password' => 'bad-toto',
              'ca_file' => File.expand_path('spec/files/ssl/ca.crt')
            }
          }
          it {expect { adapter.connection }.to raise_error(OpenSSL::PKey::RSAError) }
        end
      end
    end

    context "with CA file" do
      context "not found" do
        let(:options) {
          {
            'cert' => File.expand_path('spec/files/ssl/cert.crt'),
            'key' => File.expand_path('spec/files/ssl/key.pem'),
            'ca_file' => File.expand_path('spec/files/ssl/no-ca.crt')
          }
        }
        it { expect { adapter.connection }.to raise_error(IOError, /CA file .*no-ca.crt not found\./) }
      end
    end

    context "all correct" do
      let(:options) {
        {
          'cert' => File.expand_path('spec/files/ssl/cert.crt'),
          'key' => File.expand_path('spec/files/ssl/key.pem'),
          'ca_file' => File.expand_path('spec/files/ssl/ca.crt'),
          'verify_peer' => '1'
        }
      }
      it { expect { adapter.connection }.not_to raise_error }
    end

  end

end
