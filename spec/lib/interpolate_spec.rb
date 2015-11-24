require 'spec_helper'

describe Hieracles::Interpolate do
  include Hieracles::Interpolate

  describe ".parse" do
    let(:input) { StringIO.new }
    let(:output) { StringIO.new }
    before { setio input, output }

    context "when in non-interactive mode" do
      let(:data) { 'something_%{a_var}' }
      context "and has valid value" do
        let(:values) { { a_var: 'value' } }
        let(:expected) { 'something_value' }
        it { expect(parse data, values).to eq expected }
      end
      context "and has invalid value" do
        let(:values) { { b_var: 'novalue' } }
        let(:expected) { 'something_' }
        it { expect(parse data, values).to eq expected }
      end
      context "and has valid value with doublecolumn" do
        let(:data) { 'something_%{::a_var}' }
        let(:values) { { a_var: 'value' } }
        let(:expected) { 'something_value' }
        it { expect(parse data, values).to eq expected }
      end
    end
    context "when in interactive mode" do
      let(:data) { 'something_%{a_var}' }
      context "and has valid value" do
        let(:values) { { a_var: 'value' } }
        let(:expected) { 'something_value' }
        it { expect(parse data, values, true).to eq expected }
      end
      context "and has invalid value" do
        let(:values) { { b_var: 'novalue' } }
        let(:expected) { 'something_value' }
        before { allow(input).to receive(:gets).and_return 'value' }
        it { expect(parse data, values, true).to eq expected }
      end
    end
  end

  describe ".ask_about" do
  end

end
