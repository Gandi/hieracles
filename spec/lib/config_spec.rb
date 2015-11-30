require 'spec_helper'

describe Hieracles::Config do
  describe '.load' do
    context 'with an existing file' do
      let(:options) { { config: 'spec/files/config.yml' } }
      let(:expected) do
        {
          classpath: File.expand_path('spec/files/farm_modules/%s.pp'),
          modulepath: File.expand_path('spec/files/modules'),
          hierafile: File.expand_path('spec/files/hiera.yaml')
        }
      end
      before { Hieracles::Config.load options }

      it 'initialize config values' do
        expect(Hieracles::Config.classpath).to eq expected[:classpath]
        expect(Hieracles::Config.modulepath).to eq expected[:modulepath]
        expect(Hieracles::Config.hierafile).to eq expected[:hierafile]
        expect(Hieracles::Config.format).to eq 'Console'
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
      before { Hieracles::Config.load options }

      it 'initialize config values' do
        expect(Hieracles::Config.classpath).to eq expected[:classpath]
        expect(Hieracles::Config.modulepath).to eq expected[:modulepath]
        expect(Hieracles::Config.hierafile).to eq expected[:hierafile]
        expect(Hieracles::Config.format).to eq 'Console'
      end
    end

    context 'with db set' do
      context 'when no param is provided' do
        let(:options) do
          { 
            config: 'spec/files/config_withdb.yml'
          }
        end
        before { Hieracles::Config.load options }
        it { expect(Hieracles::Config.usedb).to be_truthy }
      end
      context 'with nodb passed as param' do
        let(:options) do
          { 
            config: 'spec/files/config_withdb.yml',
            nodb: true
          }
        end
        before { Hieracles::Config.load options }
        it { expect(Hieracles::Config.usedb).to be_falsey }
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
        before { Hieracles::Config.load options }
        it { expect(Hieracles::Config.usedb).to be_truthy }
      end
    end


    context 'without an existing config file' do
      let(:options) do
        {
          config: 'spec/files/config_no.yml',
          basepath: 'spec/files'
        }
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
        expect(Hieracles::Config.classpath).to eq File.expand_path('spec/files/manifests/classes/%s.pp')
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

  describe '.scope' do
    context 'with a yaml file' do
      let(:options) do
        { 
          config: 'spec/files/config.yml', 
          yaml_facts: 'spec/files/facts.yaml'
        }
      end
      let(:expected) { 'Debian' }
      before { Hieracles::Config.load options }

      it { expect(Hieracles::Config.scope[:osfamily]).to eq expected }
    end
    context 'with a json file' do
      let(:options) do
        { 
          config: 'spec/files/config.yml', 
          json_facts: 'spec/files/facts.json'
        }
      end
      let(:expected) { 'Debian' }
      before { Hieracles::Config.load options }

      it { expect(Hieracles::Config.scope[:osfamily]).to eq expected }
    end
  end

  describe '.resolve_path' do
    context "when path is found" do
      let(:path) { 'README.md' }
      let(:expected) { File.expand_path('README.md') }
      it { expect(Hieracles::Config.resolve_path(path)).to eq expected }
    end
    context "when path is not found anywhere" do
      let(:path) { 'README-NOT.md' }
      it { expect { Hieracles::Config.resolve_path(path) }.to raise_error(IOError) }
    end
  end

end
