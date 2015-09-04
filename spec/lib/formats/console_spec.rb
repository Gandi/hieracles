require 'spec_helper'

describe Hieracles::Formats::Console do
  let(:node) { double("node") }
  let(:console_format) { Hieracles::Formats::Console.new node }

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
      expect(console_format.info nil).to eq expected
    end
  end

  describe ".files" do
    let(:expected) { "path1\npath2\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(console_format.files nil).to eq expected
    end
  end

  describe ".paths" do
    let(:expected) { "path1\npath2\n" }
    before {
      allow(node).to receive(:paths).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(console_format.paths nil).to eq expected
    end
  end

  describe ".build_head" do
    let(:expected) { "\e[31m[0] path1\e[0m\n\e[32m[1] path2\e[0m\n\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(console_format.send :build_head).to eq expected
    end
  end

  describe ".build_params_line" do
    let(:expected) { 
       "\e[31m[0]\e[0m \e[36mparams.this.var\e[0m value1\n"+
       "    \e[97m[1] params.this.var value2\e[0m\n"
    }
    let(:params) {
      [
        { file: 'path1', value: 'value1'},
        { file: 'path2', value: 'value2'},
      ] 
    }
    before {
      console_format.instance_variable_set(:@colors,
          {'path1' => 0, 'path2' => 1}
        )
    } 
    it "outputs proper text" do
      expect(console_format.send :build_params_line,
        "params.this.var", 
        params, 
        nil).to eq expected
    end
  end


end
