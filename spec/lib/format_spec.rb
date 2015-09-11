require 'spec_helper'

describe Hieracles::Format do

  let(:node) { double("node") }
  let(:dispatch) { Hieracles::Format.new node }
  let(:not_implemented) { "%s not implemented, please inherit from the Hieracles::Format class to implement a format.\n"}

  describe '.new' do
    it "defines a node object" do
      expect(dispatch.instance_variable_get :@node).to eq node
    end
  end

  describe ".info" do
    it "returns a message informing that this class should be inherited" do
      expect(dispatch.info nil).to eq format(not_implemented, 'info')
    end
  end
  describe ".files" do
    it "returns a message informing that this class should be inherited" do
      expect(dispatch.files nil).to eq format(not_implemented, 'files')
    end
  end
  describe ".paths" do
    it "returns a message informing that this class should be inherited" do
      expect(dispatch.paths nil).to eq format(not_implemented, 'paths')
    end
  end


  describe ".build_head" do
    it "returns a message informing that this class should be inherited" do
      expect(dispatch.send :build_head, true).to eq format(not_implemented, 'build_head')
    end
  end
  describe ".build_params_line" do
    it "returns a message informing that this class should be inherited" do
      expect(dispatch.send :build_params_line, nil, nil, nil).to eq format(not_implemented, 'build_params_line')
    end
  end
  describe ".build_modules_line" do
    it "returns a message informing that this class should be inherited" do
      expect(dispatch.send :build_modules_line, nil, nil).to eq format(not_implemented, 'build_modules_line')
    end
  end

  describe ".params" do
    let(:params) { { k: 'v', kk: 'vv'} }
    let(:expected) {
      format(not_implemented, 'build_head') +
      format(not_implemented, 'build_params_line') +
      format(not_implemented, 'build_params_line')
    }
    before { allow(node).to receive(:params).and_return(params) }
    it "returns 4 lines" do
      expect(dispatch.params []).to eq expected
    end
  end

  describe ".allparams" do
    let(:params) { { k: 'v', kk: 'vv'} }
    let(:expected) {
      format(not_implemented, 'build_head') +
      format(not_implemented, 'build_params_line') +
      format(not_implemented, 'build_params_line')
    }
    before { 
      allow(node).to receive(:add_common).and_return(nil) 
      allow(node).to receive(:params).and_return(params) 
    }
    it "returns 4 lines" do
      expect(dispatch.allparams []).to eq expected
    end
  end

  describe ".modules" do
    let(:modules) { { k: 'v', kk: 'vv'} }
    let(:expected) {
      format(not_implemented, 'build_modules_line') +
      format(not_implemented, 'build_modules_line')
    }
    before { 
      allow(node).to receive(:modules).and_return(modules) 
    }
    it "returns 2 lines" do
      expect(dispatch.modules []).to eq expected
    end
  end

end
