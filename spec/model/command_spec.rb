require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/model/command'

describe TaskwarriorWeb::Command do
  describe '#initialize' do
    context 'when the command, id, and params are specified' do
      it 'should set the passed variables' do
        command = TaskwarriorWeb::Command.new('test', 3, :hello => :hi, :none => :none)
        command.command.should eq('test')
        command.id.should eq(3)
        command.params.should eq({ :hello => :hi, :none => :none })
      end
    end

    it 'should not set an @id if none is passed' do
      command = TaskwarriorWeb::Command.new('test', nil, :hello => :hi, :none => :none)
      command.command.should eq('test')
      command.id.should be_nil
      command.params.should eq({ :hello => :hi, :none => :none })
    end
  end
end
