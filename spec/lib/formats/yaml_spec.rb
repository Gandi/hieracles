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

  describe ".build_head" do
    let(:expected) { "" }
    it "outputs proper text" do
      expect(yaml_format.send :build_head).to eq expected
    end
  end

end
