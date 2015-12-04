require 'spec_helper'

describe Hieracles::Formats::Console do
  let(:node) { double("node") }
  let(:console_format) { Hieracles::Formats::Console.new node }

  describe ".info" do
    let(:expected) {
      "\e[97mNode  \e[0m fqdn\n" +
      "\e[97mFarm  \e[0m farm\n"
    }
    before {
      allow(node).to receive(:info).and_return(
        {
          'Node' => 'fqdn',
          'Farm' => 'farm'
        }
      )
      allow(node).to receive(:notifications).and_return(nil)
    }
    it "outputs proper text" do
      expect(console_format.info []).to eq expected
    end
  end

  describe ".facts" do
    let(:expected) {
      "\e[97mNode  \e[0m fqdn\n" +
      "\e[97mFarm  \e[0m farm\n"
    }
    before {
      allow(node).to receive(:facts).and_return(
        {
          'Node' => 'fqdn',
          'Farm' => 'farm'
        }
      )
      allow(node).to receive(:notifications).and_return(nil)
    }
    it "outputs proper text" do
      expect(console_format.facts []).to eq expected
    end
  end


  describe ".files" do
    let(:expected) { "path1\npath2\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(console_format.files []).to eq expected
    end
  end

  describe ".paths" do
    let(:expected) { "path1\npath2\n" }
    before {
      allow(node).to receive(:paths).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(console_format.paths []).to eq expected
    end
  end

  describe ".build_head" do
    let(:expected) { "[-] (merged)\n\e[31m[0] path1\e[0m\n\e[32m[1] path2\e[0m\n\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it "outputs proper text" do
      expect(console_format.send :build_head, true).to eq expected
    end
  end

  describe ".build_params_line" do
    context "when not merged" do
      let(:expected) { 
         "\e[32m[1]\e[0m \e[36mparams.this.var\e[0m value2\n"+
         "    \e[97m[0] params.this.var value1\e[0m\n"
      }
      let(:params) {
        [
          { file: 'path1', value: 'value1', merged: 'value1'},
          { file: 'path2', value: 'value2', merged: 'value2'},
        ] 
      }
      before {
        console_format.instance_variable_set(:@colors,
            {'path1' => 0, 'path2' => 1}
          )
      } 
      it "outputs proper text" do
        expect(console_format.send :build_params_line,
          "params.this.var", 
          params, 
          nil).to eq expected
      end
    end
    context "when merged" do
      let(:expected) { 
         "[-] \e[36mparams.this.var\e[0m [\"value1\", \"value2\"]\n"+
         "    \e[97m[1] params.this.var [\"value2\"]\e[0m\n"+
         "    \e[97m[0] params.this.var [\"value1\"]\e[0m\n"
      }
      let(:params) {
        [
          { file: 'path1', value: ['value1'], merged: ['value1'] },
          { file: 'path2', value: ['value2'], merged: ['value1','value2'] }
        ] 
      }
      before {
        console_format.instance_variable_set(:@colors,
            {'path1' => 0, 'path2' => 1}
          )
      } 
      it "outputs proper text" do
        expect(console_format.send :build_params_line,
          "params.this.var", 
          params, 
          nil).to eq expected
      end
    end
  end

  describe ".build_modules_line" do
    before {
      allow(node).to receive(:modules).and_return(
        { 
          'module1' => nil, 
          'longmodule2' => nil
        }
      )
    }
    context "module is found" do
      let(:expected) { "module1        value\n" }
      it "outputs proper text" do
        expect(console_format.send :build_modules_line, "module1", "value").to eq expected
      end
    end
    context "module is not found" do
      let(:expected) { "module1        \e[31mnot found\e[0m\n" }
      it "outputs proper text" do
        expect(console_format.send :build_modules_line, "module1", "not found").to eq expected
      end
    end
    context "module is duplicate" do
      let(:expected) { "module1        \e[33m(duplicate)\e[0m\n" }
      it "outputs proper text" do
        expect(console_format.send :build_modules_line, "module1", "(duplicate)").to eq expected
      end
    end
  end

  describe ".sanitize" do
    let(:value) { "something with % inside" }
    let(:expected) { "something with %% inside" }
    it { expect(console_format.send :sanitize, value).to eq expected }
  end

end
