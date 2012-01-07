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
    it 'should call the Runner with the task ID' do
      TaskwarriorWeb::Runner.should_receive(:run).with('3 done')
      TaskwarriorWeb::Task.complete! 3
    end
  end

  describe '.count' do
    it 'should call the Runner with the count command' do
      TaskwarriorWeb::Runner.should_receive(:run).with('count')
      TaskwarriorWeb::Task.count
    end
  end

  describe '.method_missing' do
    it 'should make the class respond to find_by queries' do
      TaskwarriorWeb::Task.should respond_to(:find_by_test)
    end

    it 'should not add support for obviously bogus methods' do
      TaskwarriorWeb::Task.should_not respond_to(:wefiohhohiihihih)
    end
  end
end
