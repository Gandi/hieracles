require 'spec_helper'

describe Hieracles::Puppetdb::Response do

  describe '.new' do
    let(:data) { 'something' }
    let(:total_records) { 2 }
    let(:response) { Hieracles::Puppetdb::Response.new(data, total_records) }
    it { expect(response.data).to eq data }
    it { expect(response.total_records).to eq total_records }
  end

end
