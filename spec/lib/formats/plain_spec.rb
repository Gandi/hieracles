require 'spec_helper'

describe Hieracles::Formats::Plain do
  let(:node) { double("node") }
  let(:plain_format) { Hieracles::Formats::Plain.new node }

  describe ".info" do
    let(:expected) {
      "Node   fqdn\n" +
      "Farm   farm\n"
    }
    before {
      allow(node).to receive(:info).and_return(
        {
          'Node' => 'fqdn',
          'Farm' => 'farm'
        }
      )
      allow(node).to receive(:notifications).and_return(nil)
    }
    it "outputs proper text" do
      expect(plain_format.info nil).to eq expected
    end
  end

  describe ".facts" do
    let(:expected) {
      "Node   fqdn\n" +
      "Farm   farm\n"
    }
    before {
      allow(node).to receive(:facts).and_return(
        {
          'Node' => 'fqdn',
          'Farm' => 'farm'
        }
      )
      allow(node).to receive(:notifications).and_return(nil)
    }
    it "outputs proper text" do
      expect(plain_format.facts nil).to eq expected
    end
  end

  describe ".files" do
    let(:expected) { "path1\npath2\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(plain_format.files nil).to eq expected
    end
  end

  describe ".paths" do
    let(:expected) { "path1\npath2\n" }
    before {
      allow(node).to receive(:paths).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(plain_format.paths nil).to eq expected
    end
  end

  describe ".build_head" do
    let(:expected) { "[-] (merged)\n[0] path1\n[1] path2\n\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(plain_format.send :build_head, true).to eq expected
    end
  end

  describe ".build_params_line" do
    context "when not merged" do
      let(:expected) { 
         "[1] params.this.var value2\n"+
         "    [0] params.this.var value1\n"
      }
      let(:params) {
        [
          { file: 'path1', value: 'value1', merged: 'value1'},
          { file: 'path2', value: 'value2', merged: 'value2'},
        ] 
      }
      before {
        plain_format.instance_variable_set(:@index,
            {'path1' => 0, 'path2' => 1}
          )
      } 
      it "outputs proper text" do
        expect(plain_format.send :build_params_line,
          "params.this.var", 
          params, 
          nil).to eq expected
      end
    end
    context "when merged" do
      let(:expected) { 
         "[-] params.this.var [\"value1\", \"value2\"]\n"+
         "    [1] params.this.var [\"value2\"]\n"+
         "    [0] params.this.var [\"value1\"]\n"
      }
      let(:params) {
        [
          { file: 'path1', value: ['value1'], merged: ['value1'] },
          { file: 'path2', value: ['value2'], merged: ['value1','value2'] },
        ] 
      }
      before {
        plain_format.instance_variable_set(:@index,
            {'path1' => 0, 'path2' => 1}
          )
      } 
      it "outputs proper text" do
        expect(plain_format.send :build_params_line,
          "params.this.var", 
          params, 
          nil).to eq expected
      end
    end
  end

  describe ".build_modules_line" do
    before {
      allow(node).to receive(:modules).and_return(
        { 
          'module1' => nil, 
          'longmodule2' => nil
        }
      )
    }
    let(:expected) { "module1        value\n" }
    it "outputs proper text" do
      expect(plain_format.send :build_modules_line, "module1", "value").to eq expected
    end
  end
  
end
