require 'spec_helper'

describe Hieracles::Config do
  describe '.load' do
    context 'with an existing file' do
      let(:options) do
        { 'c' => File.expand_path('../../files/config.yml', __FILE__) }
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
        { 'c' => File.expand_path('../../files/config_no.yml', __FILE__) }
      end
      before do
        FileUtils.rm(options['c']) if File.exist? options['c']
        Hieracles::Config.load options
      end
      after { FileUtils.rm(options['c']) if File.exist? options['c'] }

      it 'creates a default config file' do
        expect(File.exist? options['c']).to be_truthy
      end

      it 'initialize config values' do
        expect(Hieracles::Config.classpath).to eq 'manifests/classes/%s.pp'
        expect(Hieracles::Config.colors).to be_truthy
      end
    end
  end
end
