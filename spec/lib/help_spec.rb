require 'spec_helper'

describe Hieracles::Help do

  describe '.usage' do
    it { expect(subject.usage).to be_a String }
  end
end
