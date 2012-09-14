require File.dirname(__FILE__) + '/../../spec_helper'
require 'taskwarrior-web/command'

describe TaskwarriorWeb::CommandBuilder::Base do
  describe '#substitute_parts' do
    before do
      @command = TaskwarriorWeb::Command.new(:complete, 34588)
    end

    it 'should throw an error if the command has no task ID' do
      @command.id = nil
      expect { @command.substitute_parts }.to raise_error(TaskwarriorWeb::CommandBuilder::MissingTaskIDError)
    end
  end

  describe '#parse_params' do
    it 'should create a string from the passed paramters' do
      command = TaskwarriorWeb::Command.new(:query, nil, :test => 14, :none => :none, :hello => :hi)
      command.parse_params
      command.params.should eq(' test:14 none:none hello:hi')
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

    it 'should pull out the description parameter' do
      command = TaskwarriorWeb::Command.new(:add, nil, :description => 'Hello', :status => :pending)
      command.parse_params
      command.params.should eq(" Hello status:pending")
    end
  end  
end
