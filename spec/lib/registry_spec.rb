require 'spec_helper'

describe Hieracles::Registry do
	let(:base) { File.expand_path('../../../', __FILE__)}
  let(:options) do
    { 
      config: 'spec/files/config.yml', 
      basepath: 'spec/files'
    }
  end

  describe '.farms' do
    let(:config) { Hieracles::Config.new options }
    let(:expected) { [
        'dev',
        'dev2',
        'dev4'
    ] }
    it { expect(Hieracles::Registry.farms config).to eq expected }
  end

  describe '.nodes' do
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

  describe '.nodes_parameters' do
    let(:expected) {
      {
        'server.example.com' => {
          'country' => 'fr',
          'datacenter' => 'equinix',
          'farm' => 'dev'
        },
        'server2.example.com' => {
          'country' => 'fr',
          'datacenter' => 'equinix',
          'farm' => 'dev2'
        },
        'server3.example.com' => {
          'country' => 'fr',
          'datacenter' => 'equinix',
          'farm' => 'dev3'
        },
        'server4.example.com' => {
          'country' => 'fr',
          'datacenter' => 'equinix',
          'farm' => 'dev2'
        }
      }
    }
    let(:config) { Hieracles::Config.new options }
    it { expect(Hieracles::Registry.nodes_parameters config).to eq expected }
  end

  describe '.farms_counted' do
    let(:expected) { 
      {
        'dev' => 1,
        'dev2' => 2,
        'dev4' => 0
      }
    }
    let(:config) { Hieracles::Config.new options }
    it { expect(Hieracles::Registry.farms_counted config).to eq expected }
  end


end
