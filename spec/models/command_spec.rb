require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/command'

describe TaskwarriorWeb::Command do
  describe '.initialize' do
    context 'when the command, id, and params are specified' do
      it 'should set the passed variables' do
        command = TaskwarriorWeb::Command.new('test', 3, :hello => :hi, :none => :none)
        command.command.should eq('test')
        command.id.should eq(3)
        command.params.should eq({ :hello => :hi, :none => :none })
      end
    end

    it 'should raise an exception if no command is specified' do
      expect { TaskwarriorWeb::Command.new(nil, 4) }.to raise_error(TaskwarriorWeb::MissingCommandError)
    end

    it 'should not set an @id if none is passed' do
      command = TaskwarriorWeb::Command.new('test', nil, :hello => :hi, :none => :none)
      command.command.should eq('test')
      command.id.should be_nil
      command.params.should eq({ :hello => :hi, :none => :none })
    end
  end

  describe '#run' do
    before do
      @command = TaskwarriorWeb::Command.new('test', 4)
    end

    it 'should pass the object to the Runner' do
      TaskwarriorWeb::Runner.should_receive(:run).with(@command).and_return('{}')
      @command.run
    end
  end

  describe '#parse_params' do
    before do
      @command = TaskwarriorWeb::Command.new('test', nil, :hello => :hi, :none => :some)
    end

    it 'should return a string like "param:value param:value' do
      @command.send(:parse_params).should eq(' hello:hi none:some')
    end
  end
end
