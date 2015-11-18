require 'spec_helper'

describe Hieracles::Formats::Csv do
  let(:node) { double("node") }
  let(:csv_format) { Hieracles::Formats::Csv.new node }

  describe ".info" do
    let(:expected) {"fqdn;farm\n"}
    before {
      allow(node).to receive(:info).and_return(
        {
          'Node' => 'fqdn',
          'Farm' => 'farm'
        }
      )
    }
    it "outputs proper text" do
      expect(csv_format.info nil).to eq expected
    end
  end

  describe ".files" do
    let(:expected) { "path1;path2\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(csv_format.files nil).to eq expected
    end
  end
  
  describe ".paths" do
    let(:expected) { "path1;path2\n" }
    before {
      allow(node).to receive(:paths).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(csv_format.paths nil).to eq expected
    end
  end

  describe ".build_head" do
    let(:expected) { "path1;path2;var;value;overriden\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(csv_format.send :build_head, true).to eq expected
    end
  end

  describe ".build_params_line" do
    let(:expected) { 
       "0;1;params.this.var;value2;0\n"+
       "1;0;params.this.var;value1;1\n"
    }
    let(:params) {
      [
        { file: 'path1', value: 'value1'},
        { file: 'path2', value: 'value2'},
      ] 
    }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(csv_format.send :build_params_line,
        "params.this.var", 
        params, 
        nil).to eq expected
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
    let(:expected) { "module1;value\n" }
    it "outputs proper text" do
      expect(csv_format.send :build_modules_line, "module1", "value").to eq expected
    end
  end

end
