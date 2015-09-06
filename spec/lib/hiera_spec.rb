require 'spec_helper'

describe Hieracles::Hiera do

  describe '.new' do

    context 'hiera file not found' do
      let(:hierafile) { File.expand_path('../../files/hiera_no.yaml', __FILE__) }
      it 'raises an error' do
        expect(Hieracles::Hiera.new hierafile).to raise_error
      end
    end
    
    context 'hiera file found' do
      let(:hierafile) { File.expand_path('../../files/hiera.yaml', __FILE__) }
      let(:hiera) { Hieracles::Hiera.new hierafile }
      it 'load the file' do
        expect(hiera.instance_variable_get :@loaded).to be_a Hash
      end
    end

  end

end
