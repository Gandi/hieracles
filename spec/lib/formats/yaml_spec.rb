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
    it "outputs proper text" do
      expect(yaml_format.info nil).to eq expected
    end
  end

  describe ".files" do
    let(:expected) { "---\n- path1\n- path2\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(yaml_format.files nil).to eq expected
    end
  end

  describe ".paths" do
    let(:expected) { "---\n- path1\n- path2\n" }
    before {
      allow(node).to receive(:paths).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(yaml_format.paths nil).to eq expected
    end
  end

  describe ".modules" do
    before {
      allow(node).to receive(:modules).and_return(
        { 
          'module1' => "value", 
          'longmodule2' => "not found"
        }
      )
    }
    let(:expected) { "---\nmodule1: value\nlongmodule2: not found\n" }
    it "outputs proper text" do
      expect(yaml_format.modules nil).to eq expected
    end
  end

  describe ".params" do
    let(:expected) { 
       "---\n"+
       "params:\n" +
       "  this:\n" +
       "    var: value1\n"
    }
    before {
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
    it "outputs proper text" do
      expect(yaml_format.params nil).to eq expected
    end
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
