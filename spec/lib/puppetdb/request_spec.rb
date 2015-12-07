require 'spec_helper'

describe Hieracles::Puppetdb::Request do

  describe '.new' do
    let(:request) { Hieracles::Puppetdb::Request.new({}) }
    it { expect(request.instance_variable_get(:@client)).to be_a(Hieracles::Puppetdb::Client) }
  end

  describe '.node_info' do
    let(:request) { Hieracles::Puppetdb::Request.new({}) }
    let(:expected) {
      {
        'some' => 'info'
      }
    }
    before {
      allow_any_instance_of(Hieracles::Puppetdb::Client).
        to receive(:request).
        with('nodes/some.host').
        and_return({'some' => 'info'})
    }
    it { expect(request.node_info 'some.host').to eq expected }
  end

  describe '.node_facts' do
    let(:request) { Hieracles::Puppetdb::Request.new({}) }
    let(:response) { Hieracles::Puppetdb::Response.new([{'name' => 'some', 'value' => 'info'}], 1, []) }
    let(:expected_response) { Hieracles::Puppetdb::Response.new({some: 'info'}, 1, []) }
    before {
      allow_any_instance_of(Hieracles::Puppetdb::Client).
        to receive(:request).
        with('nodes/some.host/facts').
        and_return(response)
    }
    it { expect(request.node_facts('some.host').data).to eq expected_response.data }
  end


  describe '.node_resources' do
    let(:request) { Hieracles::Puppetdb::Request.new({}) }
    let(:response) { Hieracles::Puppetdb::Response.new([{'name' => 'some', 'value' => 'info', 'title' => 'title'}], 1, []) }
    let(:expected) {
      {
        'title' => {
          'name' => 'some',
          'value' => 'info',
          'title' => 'title'
        }
      }
    }
    before {
      allow_any_instance_of(Hieracles::Puppetdb::Client).
        to receive(:request).
        with('nodes/some.host/resources').
        and_return(response)
    }
    it { expect(request.node_resources('some.host').data).to eq expected }
  end

end
