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
end
