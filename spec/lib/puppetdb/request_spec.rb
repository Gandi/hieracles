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
    let(:expected) {
      [{
        'some' => 'info'
      }]
    }
    before {
      allow_any_instance_of(Hieracles::Puppetdb::Client).
        to receive(:request).
        with('nodes/some.host/facts').
        and_return([{'some' => 'info'}])
    }
    it { expect(request.node_facts 'some.host').to eq expected }
  end


  describe '.node_resources' do
    let(:request) { Hieracles::Puppetdb::Request.new({}) }
    let(:expected) {
      [{
        'some' => 'info'
      }]
    }
    before {
      allow_any_instance_of(Hieracles::Puppetdb::Client).
        to receive(:request).
        with('nodes/some.host/resources').
        and_return([{'some' => 'info'}])
    }
    it { expect(request.node_resources 'some.host').to eq expected }
  end

end
