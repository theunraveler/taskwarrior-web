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

    it 'should not set an @id if none is passed' do
      command = TaskwarriorWeb::Command.new('test', nil, :hello => :hi, :none => :none)
      command.command.should eq('test')
      command.id.should be_nil
      command.params.should eq({ :hello => :hi, :none => :none })
    end
  end

  # Move these.
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

    it 'should prefix tags with the tag.indicator if specified' do
      TaskwarriorWeb::Config.should_receive(:property).with('tag.indicator').and_return(';')
      command = TaskwarriorWeb::Command.new(:add, nil, :tags => [:today, :tomorrow])
      TaskwarriorWeb::Runner.parsed_params(command.params).should eq(' ;today ;tomorrow') 
    end

    it 'should prefix tags with a + if no tag.indicator is specified' do
      TaskwarriorWeb::Config.should_receive(:property).with('tag.indicator').and_return(nil)
      command = TaskwarriorWeb::Command.new(:add, nil, :tags => [:today, :tomorrow])
      TaskwarriorWeb::Runner.parsed_params(command.params).should eq(' +today +tomorrow') 
    end

    it 'should pull out the description parameter' do
      command = TaskwarriorWeb::Command.new(:add, nil, :description => 'Hello', :status => :pending)
      TaskwarriorWeb::Runner.parsed_params(command.params).should eq(" 'Hello' status:pending")
    end
  end  
end
