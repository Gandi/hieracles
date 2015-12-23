require 'spec_helper'

describe Hieracles::Formats::Yaml do
  let(:node) { double("node") }
  let(:yaml_format) { Hieracles::Formats::Yaml.new node }

  describe ".info" do
    let(:expected) {"---\nNode: fqdn\nFarm: farm\n"}
    before {
      allow(node).to receive(:info).and_return(
        {
          'Node' => 'fqdn',
          'Farm' => 'farm'
        }
      )
    }
    it { expect(yaml_format.info nil).to eq expected }
  end

  describe ".facts" do
    let(:expected) {"---\nNode: fqdn\nFarm: farm\n"}
    before {
      allow(node).to receive(:facts).and_return(
        {
          'Node' => 'fqdn',
          'Farm' => 'farm'
        }
      )
    }
    it { expect(yaml_format.facts nil).to eq expected }
  end

  describe ".files" do
    let(:expected) { "---\n- path1\n- path2\n" }
    before {
      allow(node).to receive(:files).and_return(['path1', 'path2'])
    }
    it { expect(yaml_format.files nil).to eq expected }
  end

  describe ".paths" do
    let(:expected) { "---\n- path1\n- path2\n" }
    before {
      allow(node).to receive(:paths).and_return(['path1', 'path2'])
    }
    it { expect(yaml_format.paths nil).to eq expected }
  end

  describe ".modules" do
    let(:expected) { "---\nmodule1: value\nlongmodule2: not found\n" }
    before {
      allow(node).to receive(:modules).and_return(
        { 
          'module1' => "value", 
          'longmodule2' => "not found"
        }
      )
    }
    it { expect(yaml_format.modules nil).to eq expected }
  end

  describe ".params" do
    context "with args" do
      let(:expected) { 
         "---\n" +
         "params: \n" +
         "  this: \n" +
         "    var: value1 # some/file"
      }
      before {
        allow(node).to receive(:params).with(true).and_return(
          { 
            'params.this.var' => {
              file: 'some/file', 
              value: 'value1', 
              overriden: false, 
              found_in: [
                { file: 'some/file', value: 'value1' }
              ]
            }
          }
        )
        allow(node).to receive(:params_tree).with(true).and_return(
          { 
            'params' => {
              'this' => {
                'var' => 'value1'
              }
            }
          }
        )
      }
      it { expect(yaml_format.params ['some', 'things']).to eq expected }
    end
    context "without args" do
      let(:expected) { 
         "---\n" +
         "params: \n" +
         "  this: \n" +
         "    var: value1 # some/file"
      }
      before {
        allow(node).to receive(:params).and_return(
          { 
            'params.this.var' => {
              file: 'some/file', 
              value: 'value1', 
              overriden: false, 
              found_in: [
                { file: 'some/file', value: 'value1' }
              ]
            }
          }
        )
        allow(node).to receive(:params_tree).and_return(
          { 
            'params' => {
              'this' => {
                'var' => 'value1'
              }
            }
          }
        )
      }
      it { expect(yaml_format.params nil).to eq expected }
    end
  end

  describe ".allparams" do
    context 'with args' do
      let(:expected) { 
         "---\n"+
         "params: \n" +
         "  this: \n" +
         "    var: value1 # some/file"
      }
      before {
        allow(node).to receive(:params).and_return(
          { 
            'params.this.var' => {
              file: 'some/file', 
              value: 'value1', 
              overriden: false, 
              found_in: [
                { file: 'some/file', value: 'value1' }
              ]
            }
          }
        )
        allow(node).to receive(:params_tree).and_return(
          { 
            'params' => {
              'this' => {
                'var' => 'value1'
              }
            }
          }
        )
      }
      it { expect(yaml_format.allparams nil).to eq expected }
    end
    context 'without args' do
      let(:expected) { 
         "---\n"+
         "params: \n" +
         "  this: \n" +
         "    var: value1 # some/file"
      }
      before {
        allow(node).to receive(:params).with(false).and_return(
          { 
            'params.this.var' => {
              file: 'some/file', 
              value: 'value1', 
              overriden: false, 
              found_in: [
                { file: 'some/file', value: 'value1' }
              ]
            }
          }
        )
        allow(node).to receive(:params_tree).with(false).and_return(
          { 
            'params' => {
              'this' => {
                'var' => 'value1'
              }
            }
          }
        )
      }
      it { expect(yaml_format.allparams ['some', 'things']).to eq expected }
    end
  end

  describe '.mergetree' do
    context "with a simple string key-value" do
      let(:params) {
        { 
          'key' => {
            file: 'what/file', 
            value: 'value', 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: 'value1' }
            ]
          }
        }
      }
      let(:input) {
        { 'key' => 'value' }
      }
      let(:expected) {
        "\nkey: value # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with various boolean type of key-values (true)" do
      let(:params) {
        { 
          'key' => {
            file: 'what/file', 
            value: true, 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: true }
            ]
          }
        }
      }
      let(:input) {
        { 'key' => true }
      }
      let(:expected) {
        "\nkey: true # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with various null type of key-values (nil)" do
      let(:params) {
        { 
          'key' => {
            file: 'what/file', 
            value: nil, 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: nil }
            ]
          }
        }
      }
      let(:input) {
        { 'key' => nil }
      }
      let(:expected) {
        "\nkey:  # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with various boolean type of key-values (false)" do
      let(:params) {
        { 
          'key' => {
            file: 'what/file', 
            value: 'false', 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: 'false' }
            ]
          }
        }
      }
      let(:input) {
        { 'key' => false }
      }
      let(:expected) {
        "\nkey: false # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with various fixnum type of key-values" do
      let(:params) {
        { 
          'key' => {
            file: 'what/file', 
            value: '3', 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: '3' }
            ]
          }
        }
      }
      let(:input) {
        { 'key' => 3 }
      }
      let(:expected) {
        "\nkey: 3 # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with various float type of key-values" do
      let(:params) {
        { 
          'key' => {
            file: 'what/file', 
            value: '0.3', 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: '0.3' }
            ]
          }
        }
      }
      let(:input) {
        { 'key' => 0.3 }
      }
      let(:expected) {
        "\nkey: 0.3 # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with a simple array key-value" do
      let(:params) {
        { 
          'key' => {
            file: 'what/file', 
            value: ['value1', 'value2'], 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: ['value1', 'value2'] }
            ]
          }
        }
      }
      let(:input) {
        { 'key' => ['value1', 'value2'] }
      }
      let(:expected) {
        "\nkey: \n  # what/file\n  - value1\n  - value2"
      }
      let(:hiera) { Struct.new( :merge_behavior ) }
      before {
        allow(node).to receive(:hiera).and_return(
          hiera.new('deeper')
        )
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with a double array key-value" do
      let(:params) {
        { 
          'key' => {
            file: '-', 
            value: ['value3'], 
            overriden: true, 
            found_in: [
              { file: 'what/file', value: ['value3'] },
              { file: 'what/other-file', value: ['value1', 'value2'] }
            ]
          }
        }
      }
      let(:hiera) { Struct.new( :merge_behavior ) }
      context "with native merge behavior" do
        let(:input) {
          { 'key' => ['value3'] }
        }
        let(:expected) {
          "\nkey: \n  # what/file\n  # what/other-file\n  - value3"
        }
        before {
          allow(node).to receive(:hiera).and_return(
            hiera.new(:native)
          )
        }
        it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
      end
      context "with deep merge behavior" do
        let(:input) {
          { 'key' => ['value1', 'value2', 'value3'] }
        }
        let(:expected) {
          "\nkey: \n  # what/file\n  # what/other-file\n  - value1\n  - value2\n  - value3"
        }
        before {
          allow(node).to receive(:hiera).and_return(
            hiera.new(:deep)
          )
        }
        it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
      end
    end
    context "with a 2-levels string key-value" do
      let(:params) {
        { 
          'key.sublevel' => {
            file: 'what/file', 
            value: 'value', 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: 'value' }
            ]
          }
        }
      }
      let(:input) {
        { 
          'key' => {
            'sublevel' => 'value'
          }
        }
      }
      let(:expected) {
        "\nkey: \n  sublevel: value # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with 2 2-levels string key-value" do
      let(:params) {
        { 
          'key.sublevel' => {
            file: 'what/file', 
            value: 'value', 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: 'value' }
            ]
          },
          'key.sublevel2' => {
            file: 'what/file2', 
            value: 'value2', 
            overriden: false, 
            found_in: [
              { file: 'what/file2', value: 'value2' }
            ]
          }
        }
      }
      let(:input) {
        { 
          'key' => {
            'sublevel' => 'value',
            'sublevel2' => 'value2'
          }
        }
      }
      let(:expected) {
        "\nkey: \n  sublevel: value # what/file\n  sublevel2: value2 # what/file2"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with a 3-levels string key-value" do
      let(:params) {
        { 
          'key.sublevel.subsublevel' => {
            file: 'what/file', 
            value: 'value', 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: 'value' }
            ]
          }
        }
      }
      let(:input) {
        { 
          'key' => {
            'sublevel' => {
              'subsublevel' => 'value'
            }
          }
        }
      }
      let(:expected) {
        "\nkey: \n  sublevel: \n    subsublevel: value # what/file"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with a 3-levels double string key-value" do
      let(:params) {
        { 
          'key.sublevel.subsublevel' => {
            file: 'what/file', 
            value: 'value', 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: 'value' }
            ]
          },
          'key2.sublevel' => {
            file: 'what/file2', 
            value: 'value', 
            overriden: false, 
            found_in: [
              { file: 'what/file2', value: 'value' }
            ]
          }
        }
      }
      let(:input) {
        { 
          'key' => {
            'sublevel' => {
              'subsublevel' => 'value'
            }
          },
          'key2' => {
            'sublevel' => 'value'
          }
        }
      }
      let(:expected) {
        "\nkey: \n  sublevel: \n    subsublevel: value # what/file" +
        "\nkey2: \n  sublevel: value # what/file2"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
    context "with a 3-levels double string key-value and override" do
      let(:params) {
        { 
          'key.sublevel.subsublevel' => {
            file: 'what/file', 
            value: 'value', 
            overriden: false, 
            found_in: [
              { file: 'what/file', value: 'value' }
            ]
          },
          'key2.sublevel' => {
            file: '-', 
            value: 'value', 
            overriden: true, 
            found_in: [
              { file: 'what/file2', value: 'value' },
              { file: 'what/file1', value: 'value2' }
            ]
          }
        }
      }
      let(:input) {
        { 
          'key' => {
            'sublevel' => {
              'subsublevel' => 'value'
            }
          },
          'key2' => {
            'sublevel' => 'value2'
          }
        }
      }
      let(:expected) {
        "\nkey: \n  sublevel: \n    subsublevel: value # what/file" +
        "\nkey2: \n  sublevel: value2 # what/file2 # what/file1"
      }
      it { expect(yaml_format.mergetree('', [], input, params)).to eq expected }
    end
  end

end
