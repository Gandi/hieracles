require 'spec_helper'

describe Hieracles::Formats::Csv do
  let(:node) { double("node") }
  let(:csv_format) { Hieracles::Formats::Csv.new node }

  describe ".info" do
    let(:expected) {"fqdn;farm;datacenter;country\n"}
    before {
      allow(node).to receive(:fqdn).and_return("fqdn")
      allow(node).to receive(:farm).and_return("farm")
      allow(node).to receive(:datacenter).and_return("datacenter")
      allow(node).to receive(:country).and_return("country")
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
      expect(csv_format.send :build_head).to eq expected
    end
  end
 
 end
