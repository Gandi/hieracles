require 'spec_helper'

describe Hieracles::Node do
  let(:options) {
    { 
      config: 'spec/files/config.yml',
      hierafile: 'hiera.yaml',
      encpath: 'enc',
      basepath: 'spec/files'
    }
  }

  context "when extra parameters are specified" do
    describe '.new' do
      let(:extraoptions) {
        #options.merge({ 'key1' => 'value1', 'key2' => 'value2' })
        options.merge({ params: 'key1=value1;key2=value2' })
      }
      let(:node) { Hieracles::Node.new 'server.example.com', extraoptions }
      let(:expected) {
        { 
          fqdn: 'server.example.com',
          country: 'fr',
          datacenter: 'equinix',
          farm: 'dev',
          key1: 'value1',
          key2: 'value2'
        }
      }
      it { expect(node).to be_a Hieracles::Node }
      it { expect(node.hiera_params).to eq expected }
    end
  end

  context "when parameters are valid" do
    let(:node) { Hieracles::Node.new 'server.example.com', options }

    describe '.new' do
      let(:expected) {
        { 
          fqdn: 'server.example.com',
          country: 'fr',
          datacenter: 'equinix',
          farm: 'dev'
        }
      }
      it { expect(node).to be_a Hieracles::Node }
      it { expect(node.hiera_params).to eq expected }
    end

    describe '.files' do
      let(:expected) {
        [
          'nodes/server.example.com.yaml',
          'farm/dev.yaml'
        ]
      }
      it { expect(node.files).to eq expected }
    end

    describe '.paths' do
      let(:expected) {
        [
          File.join(node.hiera.datadir, 'nodes/server.example.com.yaml'),
          File.join(node.hiera.datadir, 'farm/dev.yaml')
        ]
      }
      it { expect(node.paths).to eq expected }
    end

    describe '.params' do
      let(:expected) {
        [
          [ "another.sublevel.thing", 
            [{
              value: "always",
              file: File.join(node.hiera.datadir, 'nodes/server.example.com.yaml')
            }]
          ],
          [ "common_param.subparam",
            [{
              value: "overriden", 
              file: File.join(node.hiera.datadir, 'nodes/server.example.com.yaml')
            }]
          ], 
          [ "somefarmparam", 
            [{
              value: false,
              file: File.join(node.hiera.datadir, 'farm/dev.yaml')
            }]
          ]
        ]
      }
      it { expect(node.params).to eq expected }
    end

    describe '.params_tree' do
      let(:expected) {
        {
          "another" => { 
            "sublevel" => {
              "thing" => "always"
            }
          },
          "common_param" => {
            "subparam" => "overriden"
          }, 
          "somefarmparam" => false
        }
      }
      it { expect(node.params_tree).to eq expected }
    end

    describe '.modules' do
      let(:expected) {
        [
          'module' => 'path'
        ]
      }
      #it { expect(node.modules).to eq expected }
    end

    describe '.info' do
      let(:expected) { {
        fqdn: 'server.example.com',
        datacenter: 'equinix',
        country: 'fr',
        farm: 'dev'
      } }
      it { expect(node.info).to eq expected }
    end
  end

  describe '.addfile' do
  end

  describe '.classpath' do
  end

  describe '.modulepath' do
  end

  describe '.add_modules' do
  end



end
