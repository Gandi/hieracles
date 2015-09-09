require 'spec_helper'

describe Hieracles::Config do
  describe '.load' do
    context 'with an existing file' do
      let(:options) do
        { config: File.expand_path('../../files/config.yml', __FILE__) }
      end
      before { Hieracles::Config.load options }

      it 'initialize config values' do
        expect(Hieracles::Config.classpath).to eq '../files/farm_modules/%s.pp'
        expect(Hieracles::Config.modulepath).to eq '../files/modules'
        expect(Hieracles::Config.hierafile).to eq '../files/hiera.yaml'
        expect(Hieracles::Config.format).to eq 'Console'
      end
    end

    context 'with additional parameters' do
      let(:hierapath) { File.expand_path('../../files/hiera.yaml', __FILE__) }
      let(:options) do
        { 
          config: File.expand_path('../../files/config.yml', __FILE__),
          hierafile: hierapath
        }
      end
      before { Hieracles::Config.load options }

      it 'initialize config values' do
        expect(Hieracles::Config.classpath).to eq '../files/farm_modules/%s.pp'
        expect(Hieracles::Config.modulepath).to eq '../files/modules'
        expect(Hieracles::Config.hierafile).to eq hierapath
        expect(Hieracles::Config.format).to eq 'Console'
      end
    end

    context 'without an existing config file' do
      let(:options) do
        { config: File.expand_path('../../files/config_no.yml', __FILE__) }
      end
      before do
        FileUtils.rm(options[:config]) if File.exist? options[:config]
        Hieracles::Config.load options
      end
      after { FileUtils.rm(options[:config]) if File.exist? options[:config] }

      it 'creates a default config file' do
        expect(File.exist? options[:config]).to be_truthy
      end

      it 'initialize config values' do
        expect(Hieracles::Config.classpath).to eq 'manifests/classes/%s.pp'
      end
    end
  end

  describe '.defaultconfig' do
    it { expect(Hieracles::Config.defaultconfig).to be_truthy }
  end

  describe '.extract_params' do
    let(:str)  { 'bla=blu;one=two' }
    let(:expected) { { bla: 'blu', one: 'two' } }
    it { expect(Hieracles::Config.extract_params(str)).to eq expected }
  end
end
