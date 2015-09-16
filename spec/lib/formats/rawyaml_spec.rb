require 'spec_helper'

describe Hieracles::Formats::Rawyaml do
  let(:node) { double("node") }
  let(:yaml_format) { Hieracles::Formats::Rawyaml.new node }

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

  describe ".allparams" do
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
      expect(yaml_format.allparams nil).to eq expected
    end
  end

end
