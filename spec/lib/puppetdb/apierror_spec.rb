require 'spec_helper'

describe Hieracles::Puppetdb::APIError do

  describe '.new' do
    let(:response) { Object.new }
    let(:error) { Hieracles::Puppetdb::APIError.new response }
    it { expect(error.response).to eq response }
  end
  
end
