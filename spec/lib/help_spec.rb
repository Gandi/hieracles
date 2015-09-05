require 'spec_helper'

describe Hieracles::Help do
  include Hieracles::Help

  describe '.usage' do
    it { expect(usage).to be_a String }
  end
end
