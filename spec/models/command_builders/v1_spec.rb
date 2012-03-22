require File.dirname(__FILE__) + '/../../spec_helper'
require 'taskwarrior-web/command_builders/v1'
require 'taskwarrior-web/command'
require 'ostruct'

describe TaskwarriorWeb::CommandBuilder::V1 do
  describe '#substitute_parts' do
    before do
      TaskwarriorWeb::Command.class_eval do |class_name|
        include TaskwarriorWeb::CommandBuilder::V1
      end
      @command = TaskwarriorWeb::Command.new(:complete, 34588)
    end

    it 'should replace the :id string with the given task ID' do
      TaskwarriorWeb::Task.should_receive(:query).and_return([OpenStruct.new(:uuid => 34588)])
      @command.task_command.substitute_parts
      @command.command_string.should eq('1 done')
    end
  end
end
