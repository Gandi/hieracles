require 'spec_helper'

describe Hieracles::Config do
  describe '.new' do
    context 'with an existing file' do
      let(:options) { { config: 'spec/files/config.yml' } }
      let(:expected) do
        {
          classpath: File.expand_path('spec/files/farm_modules/%s.pp'),
          modulepath: File.expand_path('spec/files/modules'),
          hierafile: File.expand_path('spec/files/hiera.yaml')
        }
      end
      let(:config) { Hieracles::Config.new options }

      it 'initialize config values' do
        expect(config.classpath).to eq expected[:classpath]
        expect(config.modulepath).to eq expected[:modulepath]
        expect(config.hierafile).to eq expected[:hierafile]
        expect(config.format).to eq 'Console'
      end
    end

    context 'with additional parameters' do
      let(:hierapath) { 'hiera.yaml' }
      let(:options) do
        { 
          config: 'spec/files/config.yml', 
          hierafile: hierapath
        }
      end
      let(:expected) do
        {
          classpath: File.expand_path('spec/files/farm_modules/%s.pp'),
          modulepath: File.expand_path('spec/files/modules'),
          hierafile: File.expand_path('spec/files/hiera.yaml')
        }
      end
      let(:config) { Hieracles::Config.new options }

      it 'initialize config values' do
        expect(config.classpath).to eq expected[:classpath]
        expect(config.modulepath).to eq expected[:modulepath]
        expect(config.hierafile).to eq expected[:hierafile]
        expect(config.format).to eq 'Console'
      end
    end

    context 'with db set' do
      context 'when no param is provided' do
        let(:options) do
          { 
            config: 'spec/files/config_withdb.yml'
          }
        end
        let(:config) { Hieracles::Config.new options }
        it { expect(config.usedb).to be true }
      end
      context 'with nodb passed as param' do
        let(:options) do
          { 
            config: 'spec/files/config_withdb.yml',
            nodb: true
          }
        end
        let(:config) { Hieracles::Config.new options }
        it { expect(config.usedb).to be false }
      end
    end

    context 'with no-db set' do
      context 'and db passed as param' do
        let(:options) do
          { 
            config: 'spec/files/config.yml',
            db: true
          }
        end
        let(:config) { Hieracles::Config.new options }
        it { expect(config.usedb).to be true }
      end
    end


    context 'without an existing config file' do
      let(:options) do
        {
          config: 'spec/files/config_no.yml',
          basepath: 'spec/files'
        }
      end
      let(:config) { Hieracles::Config.new options }
      after { FileUtils.rm(options[:config]) if File.exist? options[:config] }

      it 'creates a default config file' do
        config.classpath
        expect(File.exist? options[:config]).to be true
      end

      it 'initialize config values' do
        expect(config.classpath).to eq File.expand_path('spec/files/manifests/classes/%s.pp')
      end
    end
  end

  describe '.defaultconfig' do
    let(:config) { Hieracles::Config.new Hash.new }
    before {
      allow(config).
        to receive(:defaultconfig).
        and_return('spec/files/config.yml')
    }
    it { expect(config.defaultconfig).not_to eq nil }
  end

  describe '.extract_params' do
    let(:str)  { 'bla=blu;one=two' }
    let(:expected) { { bla: 'blu', one: 'two' } }
    let(:config) { Hieracles::Config.new Hash.new }
    before {
      allow(config).
        to receive(:defaultconfig).
        and_return('spec/files/config.yml')
    }
    it { expect(config.extract_params(str)).to eq expected }
  end

  describe '.scope' do
    context 'with a yaml file' do
      let(:options) do
        { 
          config: 'spec/files/config.yml', 
          yaml_facts: 'spec/files/facts.yaml'
        }
      end
      let(:expected) { 'Debian' }
      let(:config) { Hieracles::Config.new options }

      it { expect(config.scope[:osfamily]).to eq expected }
    end
    context 'with a json file' do
      let(:options) do
        { 
          config: 'spec/files/config.yml', 
          json_facts: 'spec/files/facts.json'
        }
      end
      let(:expected) { 'Debian' }
      let(:config) { Hieracles::Config.new options }

      it { expect(config.scope[:osfamily]).to eq expected }
    end
  end

  describe '.resolve_path' do
    let(:config) { Hieracles::Config.new Hash.new }
    before {
      allow(config).
        to receive(:defaultconfig).
        and_return('spec/files/config.yml')
    }
    context "when path is found" do
      let(:path) { 'README.md' }
      let(:expected) { File.expand_path('README.md') }
      it { expect(config.resolve_path(path)).to eq expected }
    end
    context "when path is not found anywhere" do
      let(:path) { 'README-NOT.md' }
      it { expect { config.resolve_path(path) }.to raise_error(IOError) }
    end
  end

end
