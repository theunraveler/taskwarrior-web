require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/services/runner'

describe TaskwarriorWeb::Runner do
  before do
    TestCommandClass.class_eval do |class_name|
      include TaskwarriorWeb::Runner
    end
    @object = TestCommandClass.new
  end

  describe '.included' do
    it 'should make the class respond to the run command' do
      @object.should respond_to(:run)
    end

    it 'should add a TASK_VERSION constant' do
      @object.class.const_defined?(:TASK_BIN).should be_true
    end
  end

  describe '#run' do
    before do
      @object.should_receive(:`).and_return('{"new_thing" => "old_thing"}')
    end

    context 'when the command has not been built' do
      it 'should build the command' do
        @object.should_receive(:build).and_return('build command')
        @object.run
      end
    end

    context 'when the command has been built' do
      it 'should not build the command' do
        @object.instance_variable_set(:@built, 'command set manually')
        @object.should_not_receive(:build)
        @object.run
      end
    end

    it 'should return the stdout' do
      @object.should_receive(:build).and_return('build command')
      @object.run.should eq('{"new_thing" => "old_thing"}')
    end
  end

end

class TestCommandClass; end
