require 'spec_helper'

describe Hieracles::Node do
  context "with native merge" do
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
          options.merge({ params: 'key1=value1;key2=value2' })
        }
        let(:node) { Hieracles::Node.new 'server.example.com', extraoptions }
        let(:expected) {
          { 
            classes: ['dev'],
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

    context "when parameters are not valid" do
      let(:node) { Hieracles::Node.new 'server_not_there.example.com', options }
      it { expect{ node }.to raise_error(RuntimeError) }
    end

    context "when parameters are valid" do
      let(:node) { Hieracles::Node.new 'server.example.com', options }

      describe '.new' do
        let(:expected) {
          { 
            classes: ['dev'],
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
            'params/nodes/server.example.com.yaml',
            'params/farm/dev.yaml'
          ]
        }
        it { expect(node.files).to eq expected }
      end

      describe '.paths' do
        let(:expected) {
          [
            File.join(node.hiera.datapath, 'nodes/server.example.com.yaml'),
            File.join(node.hiera.datapath, 'farm/dev.yaml')
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
                file: 'params/nodes/server.example.com.yaml'
              }]
            ],
            [ "common_param.subparam",
              [{
                value: "overriden", 
                file: 'params/nodes/server.example.com.yaml'
              }]
            ], 
            [ "somefarmparam", 
              [{
                value: false,
                file: 'params/farm/dev.yaml'
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
        context "no unfound modules" do
          let(:expected) {
            {
              "fake_module" => "modules/fake_module",
              "fake_module2" => "modules/fake_module2",
              "fake_module3" => "modules/fake_module3"
            }
          }
          it { expect(node.modules).to eq expected }
        end
        context "one unfound modules" do
          let(:node) { Hieracles::Node.new 'server2.example.com', options }
          let(:expected) {
            {
              "fake_module" => "modules/fake_module",
              "fake_module2" => "modules/fake_module2",
              "fake_module4" => nil
            }
          }
          it { expect(node.modules).to eq expected }
        end
        context "no farm file found" do
          let(:node) { Hieracles::Node.new 'server3.example.com', options }
          it { expect { node.modules }.to raise_error(RuntimeError) }
        end
        context "multiple classes included" do
          let(:node) { Hieracles::Node.new 'server4.example.com', options }
          let(:expected) {
            {
              "fake_module" => "modules/fake_module",
              "fake_module2" => "modules/fake_module2",
              "fake_module4" => nil,
              "faux_module1" => "modules/faux_module1",
              "faux_module2" => "modules/faux_module2"
            }
          }
          it { expect(node.modules).to eq expected }
        end
      end

      describe '.info' do
        let(:expected) { {
          classes: ['dev'],
          fqdn: 'server.example.com',
          datacenter: 'equinix',
          country: 'fr',
          farm: 'dev'
        } }
        it { expect(node.info).to eq expected }
      end

    end
  end

  context "when parameters include double-column variables" do
    let(:options) {
      { 
        config: 'spec/files/config.yml',
        hierafile: 'hiera_columns.yaml',
        encpath: 'enc',
        basepath: 'spec/files'
      }
    }
    let(:node) { Hieracles::Node.new 'server.example.com', options }

    describe '.files' do
      let(:expected) {
        [
          'params/nodes/server.example.com.yaml',
          'params/farm/dev.yaml'
        ]
      }
      it { expect(node.files).to eq expected }
    end
  end


  context "with deep merge" do
    let(:options) {
      { 
        config: 'spec/files/config.yml',
        hierafile: 'hiera_deep.yaml',
        encpath: 'enc',
        basepath: 'spec/files'
      }
    }
    let(:node) { Hieracles::Node.new 'server_deep.example.com', options }

    describe '.params' do
      let(:expected) {
        [
          [ "another.more_sublevel", 
            [{
              value: "something",
              file: 'params/farm/dev_deep.yaml'
            }]
          ],
          [ "another.sublevel.thing", 
            [{
              value: "always",
              file: 'params/nodes/server_deep.example.com.yaml'
            }]
          ],
          [ "common_param.subparam",
            [{
              value: "overriden", 
              file: 'params/nodes/server_deep.example.com.yaml'
            }]
          ], 
          [ "somefarmparam", 
            [{
              value: false,
              file: 'params/farm/dev_deep.yaml'
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
            "more_sublevel" => "something",
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

  end


  context "with deeper merge" do
    let(:options) {
      { 
        config: 'spec/files/config.yml',
        hierafile: 'hiera_deeper.yaml',
        encpath: 'enc',
        basepath: 'spec/files'
      }
    }
    let(:node) { Hieracles::Node.new 'server_deeper.example.com', options }

    describe '.params' do
      let(:expected) {
        [
          [ "another.sublevel.thing", 
            [{
              value: "always",
              file: 'params/nodes/server.example.com.yaml'
            }]
          ],
          [ "common_param.subparam",
            [{
              value: "overriden", 
              file: 'params/nodes/server.example.com.yaml'
            }]
          ], 
          [ "somefarmparam", 
            [{
              value: false,
              file: 'params/farm/dev.yaml'
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

  end

end
