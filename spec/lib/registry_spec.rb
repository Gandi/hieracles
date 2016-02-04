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
    let(:config) { Hieracles::Config.new options }
    let(:expected) { [
        'dev',
        'dev2',
        'dev4'
    ] }
    it { expect(Hieracles::Registry.farms config).to eq expected }
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
    let(:config) { Hieracles::Config.new options }
    it { expect(Hieracles::Registry.nodes config).to eq expected }
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
    let(:config) { Hieracles::Config.new options }
    it { expect(Hieracles::Registry.modules config).to eq expected }
  end

  describe '.vars' do
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
    let(:config) { Hieracles::Config.new options }
    it { expect(Hieracles::Registry.vars config).to eq expected }
  end

end
