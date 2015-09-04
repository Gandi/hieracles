require 'spec_helper'

describe Hieracles::Formats::Plain do
  let(:node) { double("node") }
  let(:plain_format) { Hieracles::Formats::Plain.new node }

  describe ".info" do
    let(:expected) {
      "Node:       fqdn\n" +
      "Farm:       farm\n" +
      "Datacenter: datacenter\n" +
      "Country:    country\n"
    }
    before {
      allow(node).to receive(:fqdn).and_return("fqdn")
      allow(node).to receive(:farm).and_return("farm")
      allow(node).to receive(:datacenter).and_return("datacenter")
      allow(node).to receive(:country).and_return("country")
    }
    it "outputs proper text" do
      expect(plain_format.info nil).to eq expected
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
    let(:expected) { "[0] path1\n[1] path2\n\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(plain_format.send :build_head).to eq expected
    end
  end

  describe ".build_params_line" do
    let(:expected) { 
       "[0] params.this.var value1\n"+
       "    [1] params.this.var value2\n"
    }
    let(:params) {
      [
        { file: 'path1', value: 'value1'},
        { file: 'path2', value: 'value2'},
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
