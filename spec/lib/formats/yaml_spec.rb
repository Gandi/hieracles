require 'spec_helper'

describe Hieracles::Formats::Yaml do
  let(:node) { double("node") }
  let(:yaml_format) { Hieracles::Formats::Yaml.new node }

  describe ".info" do
    let(:expected) {"---\nNode: fqdn\nFarm: farm\n"}
    before {
      allow(node).to receive(:info).and_return(
        {
          'Node' => 'fqdn',
          'Farm' => 'farm'
        }
      )
    }
    it { expect(yaml_format.info nil).to eq expected }
  end

  describe ".files" do
    let(:expected) { "---\n- path1\n- path2\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it { expect(yaml_format.files nil).to eq expected }
  end

  describe ".paths" do
    let(:expected) { "---\n- path1\n- path2\n" }
    before {
      allow(node).to receive(:paths).and_return(['path1', 'path2'])
    }
    it { expect(yaml_format.paths nil).to eq expected }
  end

  describe ".modules" do
    let(:expected) { "---\nmodule1: value\nlongmodule2: not found\n" }
    before {
      allow(node).to receive(:modules).and_return(
        { 
          'module1' => "value", 
          'longmodule2' => "not found"
        }
      )
    }
    it { expect(yaml_format.modules nil).to eq expected }
  end

  describe ".params" do
    let(:expected) { 
       "---\n" +
       "params: \n" +
       "  this: \n" +
       "    var: value1 # some/file"
    }
    before {
      allow(node).to receive(:params).and_return(
        { 
          'params.this.var' => [{
            file: 'some/file',
            value: 'value1'
          }]
        }
      )
      allow(node).to receive(:params_tree).and_return(
        { 
          'params' => {
            'this' => {
              'var' => 'value1'
            }
          }
        }
      )
    }
    it { expect(yaml_format.params nil).to eq expected }
  end

  describe ".allparams" do
    let(:expected) { 
       "---\n"+
       "params: \n" +
       "  this: \n" +
       "    var: value1 # some/file"
    }
    before {
      allow(node).to receive(:params).and_return(
        { 
          'params.this.var' => [{
            file: 'some/file',
            value: 'value1'
          }]
        }
      )
      allow(node).to receive(:params_tree).and_return(
        { 
          'params' => {
            'this' => {
              'var' => 'value1'
            }
          }
        }
      )
    }
    it { expect(yaml_format.allparams nil).to eq expected }
  end

  describe '.mergetree' do
    context "with a simple string key-value" do
      let(:params) {
        { 
          'key' => [{
            file: 'what/file',
            value: 'value'
          }]
        }
      }
      let(:input) {
        { 'key' => 'value' }
      }
      let(:expected) {
        "\nkey: value # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with various boolean type of key-values (true)" do
      let(:params) {
        { 
          'key' => [{
            file: 'what/file',
            value: 'value'
          }]
        }
      }
      let(:input) {
        { 'key' => true }
      }
      let(:expected) {
        "\nkey: true # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with various boolean type of key-values (false)" do
      let(:params) {
        { 
          'key' => [{
            file: 'what/file',
            value: 'value'
          }]
        }
      }
      let(:input) {
        { 'key' => false }
      }
      let(:expected) {
        "\nkey: false # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with various fixnum type of key-values" do
      let(:params) {
        { 
          'key' => [{
            file: 'what/file',
            value: 'value'
          }]
        }
      }
      let(:input) {
        { 'key' => 3 }
      }
      let(:expected) {
        "\nkey: 3 # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with various float type of key-values" do
      let(:params) {
        { 
          'key' => [{
            file: 'what/file',
            value: 'value'
          }]
        }
      }
      let(:input) {
        { 'key' => 0.3 }
      }
      let(:expected) {
        "\nkey: 0.3 # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with a simple array key-value" do
      let(:params) {
        { 
          'key' => [{
            file: 'what/file',
            value: ['value1', 'value2']
          }]
        }
      }
      let(:input) {
        { 'key' => ['value1', 'value2'] }
      }
      let(:expected) {
        "\nkey: \n  # what/file\n  - value1\n  - value2"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with a 2-levels string key-value" do
      let(:params) {
        { 
          'key.sublevel' => [{
            file: 'what/file',
            value: 'value'
          }]
        }
      }
      let(:input) {
        { 
          'key' => {
            'sublevel' => 'value'
          }
        }
      }
      let(:expected) {
        "\nkey: \n  sublevel: value # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with 2 2-levels string key-value" do
      let(:params) {
        { 
          'key.sublevel' => [{
            file: 'what/file',
            value: 'value'
          }],
          'key.sublevel2' => [{
            file: 'what/file2',
            value: 'value2'
          }]
        }
      }
      let(:input) {
        { 
          'key' => {
            'sublevel' => 'value',
            'sublevel2' => 'value2'
          }
        }
      }
      let(:expected) {
        "\nkey: \n  sublevel: value # what/file\n  sublevel2: value2 # what/file2"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with a 3-levels string key-value" do
      let(:params) {
        { 
          'key.sublevel.subsublevel' => [{
            file: 'what/file',
            value: 'value'
          }]
        }
      }
      let(:input) {
        { 
          'key' => {
            'sublevel' => {
              'subsublevel' => 'value'
            }
          }
        }
      }
      let(:expected) {
        "\nkey: \n  sublevel: \n    subsublevel: value # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with a 3-levels double string key-value" do
      let(:params) {
        { 
          'key.sublevel.subsublevel' => [{
            file: 'what/file',
            value: 'value'
          }],
          'key2.sublevel' => [{
            file: 'what/file2',
            value: 'value'
          }]
        }
      }
      let(:input) {
        { 
          'key' => {
            'sublevel' => {
              'subsublevel' => 'value'
            }
          },
          'key2' => {
            'sublevel' => 'value'
          }
        }
      }
      let(:expected) {
        "\nkey: \n  sublevel: \n    subsublevel: value # what/file" +
        "\nkey2: \n  sublevel: value # what/file2"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
  end

end
