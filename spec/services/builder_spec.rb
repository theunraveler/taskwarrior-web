require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/services/builder'

RSpec::Mocks::setup(TaskwarriorWeb::Config)

describe TaskwarriorWeb::CommandBuilder do
  describe '.included' do
    context 'when v2 is reported' do
      it 'should include CommandBuilder V2 module' do
        TaskwarriorWeb::Config.should_receive(:version).and_return(Versionomy.parse('2.0.0'))
        TestCommandClass.class_eval { include TaskwarriorWeb::CommandBuilder }
        TestCommandClass.should include(TaskwarriorWeb::CommandBuilder::V2)
      end
    end

    context 'when v1 is reported' do
      it 'should include CommandBuilder V1 module' do
        TaskwarriorWeb::Config.should_receive(:version).and_return(Versionomy.parse('1.0.0'))
        TestCommandClass.class_eval { include TaskwarriorWeb::CommandBuilder }
        TestCommandClass.should include(TaskwarriorWeb::CommandBuilder::V1)
      end
    end

    context 'when an invalid version number is reported' do
      it 'should throw an UnrecognizedTaskVersion exception' do
        TaskwarriorWeb::Config.should_receive(:version).and_return(Versionomy.parse('9.0.0'))
        expect { 
          TestCommandClass.class_eval { include TaskwarriorWeb::CommandBuilder }
        }.to raise_exception(TaskwarriorWeb::UnrecognizedTaskVersion)
      end
    end
  end
end

class TestCommandClass; end
