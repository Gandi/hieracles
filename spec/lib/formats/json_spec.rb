require 'spec_helper'

describe Hieracles::Formats::Json do
  let(:node) { double("node") }
  let(:json_format) { Hieracles::Formats::Json.new node }

  describe ".info" do
    let(:expected) { '{"Node":"fqdn","Farm":"farm"}' }
    before {
      allow(node).to receive(:info).and_return(
        {
          'Node' => 'fqdn',
          'Farm' => 'farm'
        }
      )
      allow(node).to receive(:notifications).and_return([])
    }
    it { expect(json_format.info nil).to eq expected }
  end

  describe ".facts" do
    let(:expected) { '{"Node":"fqdn","Farm":"farm"}' }
    before {
      allow(node).to receive(:facts).and_return(
        {
          'Node' => 'fqdn',
          'Farm' => 'farm'
        }
      )
      allow(node).to receive(:notifications).and_return([])
    }
    it { expect(json_format.facts nil).to eq expected }
  end

  describe ".files" do
    let(:expected) { '{"files":["path1","path2"]}' }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
      allow(node).to receive(:notifications).and_return([])
    }
    it { expect(json_format.files nil).to eq expected }
  end

  describe ".paths" do
    let(:expected) { '{"paths":["path1","path2"]}' }
    before {
      allow(node).to receive(:paths).and_return(['path1', 'path2'])
      allow(node).to receive(:notifications).and_return([])
    }
    it { expect(json_format.paths nil).to eq expected }
  end

  describe ".modules" do
    let(:expected) { "---\nmodule1: value\nlongmodule2: not found\n" }
    let(:expected) { '{"module1":"value","longmodule2":"not found"}' }
    before {
      allow(node).to receive(:modules).and_return(
        { 
          'module1' => "value", 
          'longmodule2' => "not found"
        }
      )
      allow(node).to receive(:notifications).and_return([])
    }
    it { expect(json_format.modules nil).to eq expected }
  end

  describe ".params" do
    let(:expected) { '{"params":{"this":{"var":"value1"}}}' }
    before {
      allow(node).to receive(:params).and_return(
        { 
          'params' => {
            'this' => {
              'var' => 'value1'
            }
          }
        }
      )
      allow(node).to receive(:notifications).and_return([])
    }
    it { expect(json_format.params nil).to eq expected }
  end

  describe ".allparams" do
    let(:expected) { '{"params":{"this":{"var":"value1"}}}' }
    before {
      allow(node).to receive(:params).and_return(
        { 
          'params' => {
            'this' => {
              'var' => 'value1'
            }
          }
        }
      )
      allow(node).to receive(:notifications).and_return([])
    }
    it { expect(json_format.allparams nil).to eq expected }
  end

end
