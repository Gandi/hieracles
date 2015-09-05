require 'spec_helper'

describe Hieracles::Help do

  describe '.usage' do
    include Hieracles::Help
    it { expect(usage).to be_a String }
  end
end
