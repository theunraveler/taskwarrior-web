require File.dirname(__FILE__) + '/../../spec_helper'
require 'taskwarrior-web/model/command'

describe TaskwarriorWeb::CommandBuilder::Base do
  describe '#task_command' do
    it 'should throw and exception for invalid commands' do
      command = TaskwarriorWeb::Command.new(:does_not_exist)
      expect { command.task_command }.to raise_error(TaskwarriorWeb::CommandBuilder::InvalidCommandError)
    end
  end

  describe '#substitute_parts' do
    before do
      @command = TaskwarriorWeb::Command.new(:complete, 34588)
    end

    it 'should insert the task id into the command' do
      @command.task_command.substitute_parts
      @command.command_string.should match(/uuid:34588/)
    end

    it 'should return itself' do
      @command.task_command
      @command.task_command.substitute_parts.should eq(@command)
    end

    it 'should throw an error if the command has no task ID' do
      @command.id = nil
      expect { @command.substitute_parts }.to raise_error(TaskwarriorWeb::CommandBuilder::MissingTaskIDError)
    end
  end

  describe '#parse_params' do
    it 'should create a string from the passed paramters' do
      command = TaskwarriorWeb::Command.new(:query, nil, :test => 14, :none => :none, :hello => :hi, :array => [:first, :second])
      command.parse_params
      command.params.should eq(' test:\"14\" none:\"none\" hello:\"hi\" array:\"first\" array:\"second\"')
    end

    it 'should prefix tags with the tag.indicator if specified' do
      TaskwarriorWeb::Config.should_receive(:property).with('tag.indicator').and_return(';')
      command = TaskwarriorWeb::Command.new(:add, nil, :tags => [:today, :tomorrow])
      command.parse_params
      command.params.should eq(' ;today ;tomorrow') 
    end

    it 'should prefix tags with a + if no tag.indicator is specified' do
      TaskwarriorWeb::Config.should_receive(:property).with('tag.indicator').and_return(nil)
      command = TaskwarriorWeb::Command.new(:add, nil, :tags => [:today, :tomorrow])
      command.parse_params
      command.params.should eq(' +today +tomorrow') 
    end

    it 'should remove tags using a -' do
      command = TaskwarriorWeb::Command.new(:add, nil, :remove_tags => [:test, :tag])
      command.parse_params
      command.params.should eq(' -test -tag') 
    end

    it 'should pull out the description parameter' do
      command = TaskwarriorWeb::Command.new(:add, nil, :description => 'Hello', :status => :pending)
      command.parse_params
      command.params.should eq(' Hello status:\"pending\"')
    end
  end  
end
