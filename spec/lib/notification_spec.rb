require 'spec_helper'

describe Hieracles::Notification do

  describe '.new' do
    let(:notif) { Hieracles::Notification.new 'a_source', 'a_message'}
    it { expect(notif.level).to eq 'info' }
    it { expect(notif.message).to eq 'a_message' }
    it { expect(notif.source).to eq 'a_source' }
  end

  describe '.to_hash' do
    let(:notif) { Hieracles::Notification.new 'a_source', 'a_message'}
    before {
      allow(Time).to receive(:new).and_return(Time.new(2015))
    }
    let(:expected) { 
      { 
        'source' => 'a_source',
        'level' => 'info',
        'message' => 'a_message',
        'timestamp' => Time.new(2015)
      }
    }
    it { expect(notif.to_hash).to eq expected }
  end


end
