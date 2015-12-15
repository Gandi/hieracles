require 'spec_helper'

describe Hieracles::Puppetdb::Query do

  describe '.parse' do
    context 'with a single argument not matching an assignment' do
      let(:elements) { [ 'anything' ] }
      let(:expected) { [] }
      let(:query) { Hieracles::Puppetdb::Query.new elements }
      it { expect(query.instance_variable_get(:@elements)).to eq expected }
    end
    context 'with a single argument matching an assignment' do
      let(:elements) { [ 'something=value' ] }
      let(:expected) { ['=', 'something', 'value'] }
      let(:query) { Hieracles::Puppetdb::Query.new elements }
      it { expect(query.instance_variable_get(:@elements)).to eq expected }
    end
    context 'with 2 arguments matching an assignment' do
      let(:elements) { [ 'something=value', 'another=else' ] }
      let(:expected) { ['and', ['=', 'something', 'value'], ['=', 'another', 'else']] }
      let(:query) { Hieracles::Puppetdb::Query.new elements }
      it { expect(query.instance_variable_get(:@elements)).to eq expected }
    end
    context 'with 3 arguments but only 2 match assignment' do
      let(:elements) { [ 'something=value', 'and', 'another=else' ] }
      let(:expected) { ['and', ['=', 'something', 'value'], ['=', 'another', 'else']] }
      let(:query) { Hieracles::Puppetdb::Query.new elements }
      it { expect(query.instance_variable_get(:@elements)).to eq expected }
    end
    context 'with 2 arguments separated by a or' do
      let(:elements) { [ 'something=value', 'or', 'another=else' ] }
      let(:expected) { ['or', ['=', 'something', 'value'], ['=', 'another', 'else']] }
      let(:query) { Hieracles::Puppetdb::Query.new elements }
      it { expect(query.instance_variable_get(:@elements)).to eq expected }
    end
    context 'with 3 arguments including a or' do
      let(:elements) { [ 'something=value', 'or', 'another=else', 'more=ever' ] }
      let(:expected) { 
        [ 'or',
          ['=', 'something', 'value'], 
          ['and', ['=', 'another', 'else'], ['=', 'more', 'ever']]
          ] 
      }
      let(:query) { Hieracles::Puppetdb::Query.new elements }
      it { expect(query.instance_variable_get(:@elements)).to eq expected }
    end
  end

  describe '.build_and' do
    let(:query) { Hieracles::Puppetdb::Query.new [] }
    context 'with no and' do
      let(:array) { ["a=b"]}
      let(:expected) { ['=', 'a', 'b'] }
      it { expect(query.send(:build_and, array)).to eq expected }
    end
    context 'with a single and' do
      let(:array) { ["a=b",  "a=c"]}
      let(:expected) { ['and', ['=', 'a', 'b'],['=', 'a', 'c']] }
      it { expect(query.send(:build_and, array)).to eq expected }
    end

  end

  describe '.build_or' do
    let(:query) { Hieracles::Puppetdb::Query.new [] }
    context 'with a single or' do
      let(:array) { ["a=b", "or", "a=c"]}
      let(:expected) { ['or', ['a=b'],['a=c']]}
      it { expect(query.send(:build_or, array)).to eq expected }
    end
    context 'with a double or' do
      let(:array) { ["a=b", "or", "a=c", "or", "a=d"]}
      let(:expected) { ['or', ['a=b'],['a=c'],['a=d']]}
      it { expect(query.send(:build_or, array)).to eq expected }
    end
    context 'with a double or and multiple ands' do
      let(:array) { ["a=b", "a=x", "or", "a=c", "or", "a=d"]}
      let(:expected) { ['or', ['a=b', 'a=x'],['a=c'],['a=d']]}
      it { expect(query.send(:build_or, array)).to eq expected }
    end
  end

  describe '.expression' do
    let(:query) { Hieracles::Puppetdb::Query.new [] }
    context 'with a = sign' do
      let(:string) { 'a=b' }
      let(:expected) { ['=', 'a', 'b']}
      it { expect(query.send(:expression, string)).to eq expected }      
    end
    context 'with a != sign' do
      let(:string) { 'a!=b' }
      let(:expected) { ['not', ['=', 'a', 'b']]}
      it { expect(query.send(:expression, string)).to eq expected }      
    end
    context 'with a ~ sign' do
      let(:string) { 'a~b' }
      let(:expected) { ['~', 'a', 'b']}
      it { expect(query.send(:expression, string)).to eq expected }      
    end
    context 'with a !~ sign' do
      let(:string) { 'a!~b' }
      let(:expected) { ['not', ['~', 'a', 'b']]}
      it { expect(query.send(:expression, string)).to eq expected }      
    end
  end

end
