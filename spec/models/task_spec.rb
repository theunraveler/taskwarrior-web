require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/task'

describe TaskwarriorWeb::Task do
  RSpec::Mocks::setup(TaskwarriorWeb::Runner)
  TaskwarriorWeb::Runner.stub(:run) { '{}' }

  describe '#initialize' do
    it 'should assign the passed attributes' do
      task = TaskwarriorWeb::Task.new({:entry => 'Testing', :project => 'Project'})
      task.entry.should eq('Testing')
      task.project.should eq('Project')
    end

    it 'should not assign bogus attributes' do
      task = TaskwarriorWeb::Task.new({:bogus => 'Testing'})
      task.respond_to?(:bogus).should be_false
    end
  end

  describe '.complete!' do
    it 'create and run a new command object with the task ID' do
      command = TaskwarriorWeb::Command.new(:complete, 3)
      TaskwarriorWeb::Command.should_receive(:new).with(:complete, 3).and_return(command)
      command.should_receive(:run).and_return('{}')
      TaskwarriorWeb::Task.complete! 3
    end
  end

  describe '.query' do
    it 'should create and run a new Command object' do
      command = TaskwarriorWeb::Command.new(:query)
      TaskwarriorWeb::Command.should_receive(:new).with(:query, nil, []).and_return(command)
      command.should_receive(:run).and_return('{}')
      TaskwarriorWeb::Task.query
    end

    it 'should parse the JSON received from the `task` command' do
      TaskwarriorWeb::Runner.should_receive(:run).and_return('{}')
      ::JSON.should_receive(:parse).with('[{}]').and_return([])
      TaskwarriorWeb::Task.query
    end

    it 'should not parse the results when there are no matching tasks' do
      TaskwarriorWeb::Runner.should_receive(:run).and_return('No matches.')
      ::JSON.should_not_receive(:parse)
      TaskwarriorWeb::Task.query
    end
  end

  describe '.count' do
    it 'create and run an new command object' do
      command = TaskwarriorWeb::Command.new(:count)
      TaskwarriorWeb::Command.should_receive(:new).with(:count, nil, []).and_return(command)
      command.should_receive(:run).and_return('{}')
      TaskwarriorWeb::Task.count
    end
  end

  describe '.method_missing' do
    it 'should call the query method for find_by queries' do
      TaskwarriorWeb::Task.should_receive(:query).with('status' => 'pending')
      TaskwarriorWeb::Task.find_by_status(:pending)
    end

    it 'should call pass other methods to super if not find_by_*' do
      TaskwarriorWeb::Task.should_not_receive(:query)
      Object.should_receive(:method_missing).with(:do_a_thing, anything)
      TaskwarriorWeb::Task.do_a_thing(:pending)
    end

    it 'should make the class respond to find_by queries' do
      TaskwarriorWeb::Task.should respond_to(:find_by_test)
    end

    it 'should not add support for obviously bogus methods' do
      TaskwarriorWeb::Task.should_not respond_to(:wefiohhohiihihih)
    end
  end
end
