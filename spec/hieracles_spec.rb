require 'spec_helper'

describe Hieracles do
  describe '.version' do
    let(:expected) { File.read(File.expand_path('../../CHANGELOG.md', __FILE__))[/([0-9]+\.[0-9]+\.[0-9]+)/] }
    it { expect(Hieracles.version).to eq expected }
  end
end
