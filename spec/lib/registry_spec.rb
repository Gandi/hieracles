require 'spec_helper'

describe Hieracles::Registry do
	let(:base) { File.expand_path('../../../', __FILE__)}

  describe '.farms' do
    let(:options) do
      { 
        config: 'spec/files/config.yml', 
        basepath: 'spec/files'
      }
    end
    let(:expected) { [
    		File.join(Hieracles::Config.basepath, 'farm_modules', 'dev.pp'),
    		File.join(Hieracles::Config.basepath, 'farm_modules', 'dev2.pp'),
    		File.join(Hieracles::Config.basepath, 'farm_modules', 'dev4.pp')
  	] }
    before { Hieracles::Config.load options}
    it { expect(Hieracles::Registry.farms Hieracles::Config).to eq expected }
  end

  describe '.nodes' do
    let(:options) do
      { 
        config: 'spec/files/config.yml',
        basepath: 'spec/files'
      }
    end
    let(:expected) { [
    		'server.example.com',
    		'server2.example.com',
    		'server3.example.com',
    		'server4.example.com'
  	] }
    before { Hieracles::Config.load options}
    it { expect(Hieracles::Registry.nodes Hieracles::Config).to eq expected }
  end

  describe '.modules' do
    let(:options) do
      {
        config: 'spec/files/config.yml',
        basepath: 'spec/files'
      }
    end
    let(:expected) { [
    		'fake_module',
    		'fake_module2',
    		'fake_module3',
    		'faux_module1',
    		'faux_module2'
  	] }
    before { Hieracles::Config.load options}
    it { expect(Hieracles::Registry.modules Hieracles::Config).to eq expected }
  end

end
