require 'spec_helper'

describe Hieracles::Utils do
  include Hieracles::Utils

  it '.deep_sort' do
    hash = {
      b: '',
      a: { aa: 'aa' },
      d: 'd',
      c: [cb: %w(b a c), ca: { caa: 'caa' }]
    }
    expected = {
      a: { aa: 'aa' },
      b: '',
      c: [ca: { caa: 'caa' }, cb: %w(a b c)],
      d: 'd'
    }
    expect(deep_sort hash).to eq expected
  end

  describe '.to_deep_hash' do
    before :each do
      @shallow_hash = {
        'pressrelease.label.one' => 'Pressmeddelande',
        'pressrelease.label.other' => 'Pressmeddelanden',
        'article' => 'Artikel',
        'category' => ''
      }
      @deep_hash = {
        pressrelease: {
          label: {
            one: 'Pressmeddelande',
            other: 'Pressmeddelanden'
          }
        },
        article: 'Artikel',
        category: ''
      }
    end

    it 'convert shallow hash with dot separated keys to deep hash' do
      expect(to_deep_hash @shallow_hash).to eq @deep_hash
    end

    it 'converts a deep hash to a shallow one' do
      expect(to_shallow_hash @deep_hash).to eq @shallow_hash
    end
  end

  describe '.max_key_length' do
    let(:hash) { { 'key1' => nil, 'key22' => nil, 'key9chars' => nil } }
    it { expect(max_key_length hash).to eq 9 }
  end

  describe '.sym_keys' do
    let(:hash) { { 'key1' => '1', 'key22' => '2', 'key9chars' => 3 } }
    let(:expected) { { key1: '1', key22: '2', key9chars: 3 } }
    it { expect(sym_keys hash).to eq expected }
  end
end
