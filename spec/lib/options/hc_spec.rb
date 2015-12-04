require 'spec_helper'

describe Hieracles::Options::Hc do
  describe '.initialize' do
    context 'with proper arguments' do
      let(:array) { ['arg1', 'arg2', '-c', 'path/to/config-file', '-f', 'thatformat'] }
      let(:expected_payload) { ['arg1', 'arg2'] }
      let(:expected_options) do
        { config: 'path/to/config-file', format: 'thatformat' }
      end
      subject { Hieracles::Options::Hc.new array }
      it "populates payload" do
        expect(subject.payload).to eq expected_payload
      end
      it 'populates options' do
        expect(subject.options).to eq expected_options
      end
    end

    context 'with proper arguments in random order' do
      let(:array) { ['-c', 'path/to/config-file', 'arg1', 'arg2', '-f', 'thatformat'] }
      let(:expected_payload) { ['arg1', 'arg2'] }
      let(:expected_options) do
        { config: 'path/to/config-file', format: 'thatformat' }
      end
      subject { Hieracles::Options::Hc.new array }
      it "populates payload" do
        expect(subject.payload).to eq expected_payload
      end
      it 'populates options' do
        expect(subject.options).to eq expected_options
      end
    end

    context 'with funnily ordered arguments' do
      let(:array) { ['arg1', '-u', 'path/to/config-file', 'arg2', '-f', 'thatformat'] }
      let(:expected_payload) { ['arg1', 'arg2'] }
      let(:expected_options) do
        { format: 'thatformat' }
      end
      subject { Hieracles::Options::Hc.new array }
      it "populates payload" do
        expect(subject.payload).to eq expected_payload
      end
      it 'populates options' do
        expect(subject.options).to eq expected_options
      end
    end

    context 'with arguments in alternative syntax' do
      let(:array) { ['arg1', 'arg2', '-config', 'path/to/config-file', '--format', 'thatformat'] }
      let(:expected_payload) { ['arg1', 'arg2'] }
      let(:expected_options) do
        { config: 'path/to/config-file', format: 'thatformat' }
      end
      subject { Hieracles::Options::Hc.new array }
      it "populates payload" do
        expect(subject.payload).to eq expected_payload
      end
      it 'populates options' do
        expect(subject.options).to eq expected_options
      end
    end

    context 'with arguments containing boolean element' do
      let(:array) { ['arg1', 'arg2', '-i', '-format', 'thatformat'] }
      let(:expected_payload) { ['arg1', 'arg2'] }
      let(:expected_options) do
        { format: 'thatformat', interactive: true }
      end
      subject { Hieracles::Options::Hc.new array }
      it "populates payload" do
        expect(subject.payload).to eq expected_payload
      end
      it 'populates options' do
        expect(subject.options).to eq expected_options
      end
    end

  end
end
