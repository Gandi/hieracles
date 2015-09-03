require 'spec_helper'

describe Hieracles::Config do
  describe '.load' do
    context 'with an existing file' do
      let(:options) do
        { config: File.expand_path('../../files/config.yml', __FILE__) }
      end
      before { Hieracles::Config.load options }

      it 'initialize config values' do
        expect(Hieracles::Config.classpath).to eq '../files/modules/%s.pp'
        expect(Hieracles::Config.format).to eq 'Console'
        expect(Hieracles::Config.colors).to be_falsey
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
        expect(Hieracles::Config.colors).to be_truthy
      end
    end
  end
end
