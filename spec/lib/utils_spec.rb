require 'spec_helper'
require 'hieracles/utils'

describe Hieracles::Utils do
  include Hieracles::Utils

  it 'can deep sort hashes' do
    hash = { b: '', a: { aa: 'aa' }, d: 'd', c: [cb: ['b', 'a', 'c'], ca: { caa: 'caa' }] }
    expected = { a: { aa: 'aa' }, b: '', c: [ca: { caa: 'caa' }, cb: ['a', 'b', 'c']], d: 'd' }
    expect(deep_sort hash).to eq expected
  end

  describe 'to_deep_hash' do
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


end

