require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/runner'

describe TaskwarriorWeb::Runner do
  before do
    @command = TaskwarriorWeb::Command.new(:add)
  end

  describe '.run' do
    context 'valid, without a command' do
      before do
        TaskwarriorWeb::Runner.should_receive(:`).and_return('{}')
      end

      it 'should return the stdout' do
        TaskwarriorWeb::Runner.run(@command).should eq('{}')
      end

      it 'should call .substitute_parts if the command needs a task ID' do
        command = TaskwarriorWeb::Command.new(:complete, 4)
        TaskwarriorWeb::Runner.should_receive(:substitute_parts).with(anything, command)
        TaskwarriorWeb::Runner.run(command)
      end

      it 'should not call .substitute_parts if not necessary' do
        TaskwarriorWeb::Runner.should_not_receive(:substitute_parts)
        TaskwarriorWeb::Runner.run(@command)
      end
    end

    context 'invalid' do
      it 'should throw an exception if the command is not valid' do
        @command.command = :test
        expect { TaskwarriorWeb::Runner.run(@command) }.to raise_error(TaskwarriorWeb::InvalidCommandError)
      end
    end

    context 'with a given command' do
      it 'should execute the given command' do
        TaskwarriorWeb::Runner.should_receive(:`).with('task add').and_return('{}')
        TaskwarriorWeb::Runner.run(@command)
      end
    end
  end

  describe '.substitute_parts' do
    it 'should replace the :id string with the given task ID' do
      command = TaskwarriorWeb::Command.new(:complete, 4)
      TaskwarriorWeb::Runner.substitute_parts(':id done', command).should eq('4 done')
    end

    it 'should throw an error if the command has no task ID' do
      expect { TaskwarriorWeb::Runner.substitute_parts(':id done', @command) }.to raise_error(TaskwarriorWeb::MissingTaskIDError)
    end
  end

  describe '.parsed_params' do
    it 'should create a string from the passed paramters' do
      command = TaskwarriorWeb::Command.new(:query, nil, :test => 14, :none => :none, :hello => :hi)
      TaskwarriorWeb::Runner.parsed_params(command.params).should eq(' test:14 none:none hello:hi')
    end

    it 'should prefix tags with a +' do
      command = TaskwarriorWeb::Command.new(:add, nil, :tags => [:today, :tomorrow])
      TaskwarriorWeb::Runner.parsed_params(command.params).should eq(' +today +tomorrow') 
    end

    it 'should pull out the description parameter' do
      command = TaskwarriorWeb::Command.new(:add, nil, :description => 'Hello', :status => :pending)
      TaskwarriorWeb::Runner.parsed_params(command.params).should eq(" 'Hello' status:pending")
    end
  end
end
