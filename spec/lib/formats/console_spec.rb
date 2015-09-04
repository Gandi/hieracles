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
end
