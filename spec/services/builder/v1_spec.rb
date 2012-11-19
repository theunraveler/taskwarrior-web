require File.dirname(__FILE__) + '/../../spec_helper'
require 'taskwarrior-web/services/builder/v1'
require 'taskwarrior-web/model/command'
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
      @command.task_command.substitute_parts.command_string.should eq('1 done')
    end

    it 'should throw an error if there is no id' do
      command = TaskwarriorWeb::Command.new(:complete)
      expect { command.substitute_parts }.to raise_error(TaskwarriorWeb::CommandBuilder::MissingTaskIDError)
    end
  end
end
