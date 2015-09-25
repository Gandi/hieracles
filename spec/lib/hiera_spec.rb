require 'spec_helper'

describe Hieracles::Hiera do
  before { Hieracles::Config.load(options) }

  describe '.new' do

    context 'hiera file not found' do
      let(:options) { { 
        basepath: 'spec/files',
        hierafile: 'hiera_no.yaml' 
      } }
      it 'raises an error' do
        expect { Hieracles::Hiera.new }.to raise_error(IOError)
      end
    end
    
    context 'hiera file found' do
      let(:options) { { 
        basepath: 'spec/files',
        hierafile: 'hiera.yaml' 
      } }
      let(:expected){
        File.expand_path(File.join(options[:basepath], options[:hierafile]))
      }
      let(:hiera) { Hieracles::Hiera.new }
      it 'load the file' do
        expect(hiera.instance_variable_get :@loaded).to be_a Hash
        expect(hiera.instance_variable_get :@hierafile).to eq expected
      end
    end

  end

  describe '.datapath' do
    context 'hiera file do not have a yaml backend' do
      let(:options) { { 
        basepath: 'spec/files',
        hierafile: 'hiera_no_yamlbackend.yaml' 
      } }
      let(:hiera) { Hieracles::Hiera.new }
      it 'raises an error' do
        expect { hiera.datapath }.to raise_error(TypeError)
      end
    end
    context 'hiera file has a yaml backend but dir not found' do
      let(:options) { { 
        basepath: 'spec/files',
        hierafile: 'hiera_yamlbackend_notfound.yaml' 
      } }
      let(:hiera) { Hieracles::Hiera.new }
      it 'raises an error' do
        expect { hiera.datapath }.to raise_error(IOError)
      end
    end
    context 'hiera file has a yaml backend' do
      let(:options) {
        {
          config: 'spec/files/config.yml',
          hierafile: 'hiera.yaml',
          basepath: 'spec/files'
        }
      }
      let(:hiera) { Hieracles::Hiera.new }
      let(:expected) { File.expand_path(File.join(Hieracles::Config.basepath, 'params')) }
      it 'returns params path' do
        expect(hiera.datapath).to eq expected
      end
    end
  end

  describe '.datadir' do
    let(:options) {
      {
        config: 'spec/files/config.yml',
        hierafile: 'hiera.yaml',
        basepath: 'spec/files'
      }
    }
    let(:hiera) { Hieracles::Hiera.new }
    it { expect(hiera.datadir).to eq 'params/' }
  end

  context "with proper params" do
    let(:options) { { 
      basepath: 'spec/files',
      hierafile: 'hiera.yaml' 
    } }
    let(:hiera) { Hieracles::Hiera.new }

    describe '.hierarchy' do
      let(:expected) { [
          'nodes/%{fqdn}',
          'farm_datacenter/%{farm}_%{datacenter}',
          'farm/%{farm}',
          'room/%{room}',
          'datacenter/%{datacenter}',
          'country/%{country}',
          'os/%{operatingsystem}-%{lsbdistcodename}',
          'common/common'
        ]}
      it "extracts the hierarchy accoding to the hierfile" do
        expect(hiera.hierarchy).to eq expected
      end
    end

    describe '.params' do
      let(:expected) { [
          'fqdn',
          'farm',
          'datacenter',
          'room',
          'country',
          'operatingsystem',
          'lsbdistcodename'
        ]}
      it 'extracts hiera parameters from the hierarchy' do
        expect(hiera.params).to eq expected
      end
    end
  end

end
