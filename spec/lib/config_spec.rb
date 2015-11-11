require 'spec_helper'

describe Hieracles::Config do
  describe '.load' do
    context 'with an existing file' do
      let(:options) do
        { config: 'spec/files/config.yml', basepath: 'spec/files' }
      end
      before { Hieracles::Config.load options }

      it 'initialize config values' do
        expect(Hieracles::Config.classpath).to eq 'farm_modules/%s.pp'
        expect(Hieracles::Config.modulepath).to eq 'modules'
        expect(Hieracles::Config.hierafile).to eq 'hiera.yaml'
        expect(Hieracles::Config.format).to eq 'Console'
      end
    end

    context 'with additional parameters' do
      let(:hierapath) { 'hiera.yaml' }
      let(:options) do
        { config: 'spec/files/config.yml', basepath: 'spec/files', hierafile: hierapath }
      end
      before { Hieracles::Config.load options }

      it 'initialize config values' do
        expect(Hieracles::Config.classpath).to eq 'farm_modules/%s.pp'
        expect(Hieracles::Config.modulepath).to eq 'modules'
        expect(Hieracles::Config.hierafile).to eq hierapath
        expect(Hieracles::Config.format).to eq 'Console'
      end
    end

    context 'without an existing config file' do
      let(:options) do
        { config: 'spec/files/config_no.yml' }
      end
      before do
        FileUtils.rm(options[:config]) if File.exist? options[:config]
        Hieracles::Config.load options
      end
      after { FileUtils.rm(options[:config]) if File.exist? options[:config] }

      it 'creates a default config file' do
        expect(File.exist? options[:config]).to be true
      end

      it 'initialize config values' do
        expect(Hieracles::Config.classpath).to eq 'manifests/classes/%s.pp'
      end
    end
  end

  describe '.defaultconfig' do
    it { expect(Hieracles::Config.defaultconfig).not_to eq nil }
  end

  describe '.extract_params' do
    let(:str)  { 'bla=blu;one=two' }
    let(:expected) { { bla: 'blu', one: 'two' } }
    it { expect(Hieracles::Config.extract_params(str)).to eq expected }
  end

  describe '.facts' do
    context 'with a yaml file' do
      let(:options) do
        { 
          config: 'spec/files/config.yml', 
          basepath: 'spec/files', 
          yaml_facts: 'spec/files/facts.yaml'
        }
      end
      let(:expected) { 'Debian' }
      before { Hieracles::Config.load options }

      it { expect(Hieracles::Config.facts['osfamily']).to eq expected }
    end
    context 'with a json file' do
      let(:options) do
        { 
          config: 'spec/files/config.yml', 
          basepath: 'spec/files', 
          json_facts: 'spec/files/facts.json'
        }
      end
      let(:expected) { 'Debian' }
      before { Hieracles::Config.load options }

      it { expect(Hieracles::Config.facts['osfamily']).to eq expected }
    end
  end

end
