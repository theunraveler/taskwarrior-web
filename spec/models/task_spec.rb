require 'taskwarrior-web/task'

describe TaskwarriorWeb::Task do

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
end
