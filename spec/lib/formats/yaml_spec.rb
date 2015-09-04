require 'spec_helper'

describe Hieracles::Formats::Yaml do
  let(:node) { double("node") }
  let(:yaml_format) { Hieracles::Formats::Yaml.new node }

  describe ".info" do
    let(:expected) {"---\nnode: fqdn\nfarm: farm\ndatacenter: datacenter\ncountry: country\n"}
    before {
      allow(node).to receive(:fqdn).and_return("fqdn")
      allow(node).to receive(:farm).and_return("farm")
      allow(node).to receive(:datacenter).and_return("datacenter")
      allow(node).to receive(:country).and_return("country")
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

  describe ".build_head" do
    let(:expected) { "" }
    it "outputs proper text" do
      expect(yaml_format.send :build_head).to eq expected
    end
  end

end
