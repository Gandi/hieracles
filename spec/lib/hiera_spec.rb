require 'spec_helper'

describe Hieracles::Hiera do
  before { Hieracles::Config.load(options) }

  describe '.new' do
    context 'hiera file not found' do
      let(:options) { { hierafile: File.expand_path('../../files/hiera_no.yaml', __FILE__) } }
      it 'raises an error' do
        expect { Hieracles::Hiera.new }.to raise_error(IOError)
      end
    end
    context 'hiera file found' do
      let(:options) { { hierafile: File.expand_path('../../files/hiera.yaml', __FILE__) } }
      let(:hiera) { Hieracles::Hiera.new }
      it 'load the file' do
        expect(hiera.instance_variable_get :@loaded).to be_a Hash
        expect(hiera.instance_variable_get :@hierafile).to eq options[:hierafile]
      end
    end
  end

  describe '.datadir' do
    context 'hiera file do not have a yaml backend' do
      let(:options) { { hierafile: File.expand_path('../../files/hiera_no_yamlbackend.yaml', __FILE__) } }
      let(:hiera) { Hieracles::Hiera.new }
      it 'raises an error' do
        expect { hiera.datadir }.to raise_error(TypeError)
      end
    end
    context 'hiera file has a yaml backend but dir not found' do
      let(:options) { { hierafile: File.expand_path('../../files/hiera_yamlbackend_notfound.yaml', __FILE__) } }
      let(:hiera) { Hieracles::Hiera.new }
      it 'raises an error' do
        expect { hiera.datadir }.to raise_error(IOError)
      end
    end
    context 'hiera file has a yaml backend' do
      let(:options) {
        {
          config: File.expand_path('../../files/config.yml', __FILE__),
          hierafile: File.expand_path('../../files/hiera.yaml', __FILE__),
          basepath: File.expand_path('../../files', __FILE__)
        }
      }
      let(:hiera) { Hieracles::Hiera.new }
      let(:parampath) { File.expand_path('../params/', options[:hierafile]) }
      it 'returns params path' do
        expect(hiera.datadir).to eq parampath
      end
    end
  end

  describe '.hierarchy' do
    let(:options) { { hierafile: File.expand_path('../../files/hiera.yaml', __FILE__) } }
    let(:hiera) { Hieracles::Hiera.new }
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
    let(:options) { { hierafile: File.expand_path('../../files/hiera.yaml', __FILE__) } }
    let(:hiera) { Hieracles::Hiera.new }
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
