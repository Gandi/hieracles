require 'spec_helper'

describe Hieracles::Puppetdb::Client do

  describe '.new' do
    context 'when no option is passed' do
      let(:client) { Hieracles::Puppetdb::Client.new Hash.new }
      it { expect(client.class.instance_variable_get(:@default_options)[:base_uri]).to eq 'http://localhost:8080/v3' }
    end
  end
  
  describe '.setup_if_ssl' do
    let(:basepath) { 'spec/files' }
    let(:options) {
      {
        'usessl' => true,
        'key' => File.join(basepath, 'ssl', 'key.pem'),
        'cert' => File.join(basepath, 'ssl', 'cert.crt'),
        'ca_file' => File.join(basepath, 'ssl', 'ca.crt')
      }
    }
    let(:client) { Hieracles::Puppetdb::Client.new options }
    it { expect(client.class.instance_variable_get(:@default_options)[:options]).to eq options }
  end

  describe '.request' do
    context 'with a GET request' do
      let(:client) { Hieracles::Puppetdb::Client.new Hash.new }
      let(:request) { client.request('endpoint', 'get')}
      let(:response) { Hieracles::Puppetdb::Response.new(Hash.new, 0, Array.new) }
      before {
        resp = double
        allow(resp).
          to receive(:code).
          and_return(200)
        allow(resp).
          to receive(:parsed_response).
          and_return('')
        allow(client).
          to receive(:get_request).
          with('endpoint', nil, {}).
          and_return(resp)
      }
      it { expect(request.data).to eq Hash.new }
      it { expect(request.notifications.count).to eq 1 }
    end
  end

  describe '.get_request' do
    let(:client) { Hieracles::Puppetdb::Client.new Hash.new }
    context 'without query' do
      let(:request) { client.request('endpoint', 'get')}
      before {
        allow(client.class).
          to receive(:get).
          and_return('ha')
      }
      let(:get_request) { client.get_request('endpoint', nil, Hash.new) }
      it { expect(get_request).to eq 'ha' }
    end
  end

  
end
