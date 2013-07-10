require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web'

set :environment, :test

describe TaskwarriorWeb::App do
  include Rack::Test::Methods

  def app
    TaskwarriorWeb::App
  end

  before do
    allow(TaskwarriorWeb::Config).to receive(:property).with('task-web.user').and_return(nil)
    allow(TaskwarriorWeb::Config).to receive(:property).with('task-web.filter').and_return(nil)
    allow(TaskwarriorWeb::Runner).to receive(:run).and_return('{}')
  end

  ['/', '/tasks'].each do |path|
    describe "GET #{path}" do
      it 'should redirect to /tasks/pending' do
        get path
        follow_redirect!

        last_request.url.should match(/tasks\/pending$/)
        last_response.should be_ok
      end
    end
  end

  describe 'GET /tasks/new' do
    it 'should display a new task form' do
      get '/tasks/new'
      last_response.body.should have_tag('form', :with => { :action => '/tasks' })
    end

    it 'should display a 200 status code' do
      get '/tasks/new'
      last_response.should be_ok
    end
  end

  describe 'POST /tasks' do
    context 'given a valid task' do
      it 'should save the task' do
        task = TaskwarriorWeb::Task.new({:description => 'Test task'})
        task.should_receive(:save!).once
        TaskwarriorWeb::Task.should_receive(:new).once.and_return(task)
        post '/tasks', :task => {:description => 'Test task'}
      end

      it 'should redirect to the task listing page' do
        task = TaskwarriorWeb::Task.new({:description => 'Test task'})
        task.should_receive(:is_valid?).and_return(true)
        task.should_receive(:save!)
        TaskwarriorWeb::Task.should_receive(:new).once.and_return(task)
        post '/tasks', :task => {:description => 'Test task'}
        follow_redirect!
        last_request.url.should match(/tasks$/)
      end
    end

    context 'given an invalid task' do
      it 'should not save the task' do
        task = TaskwarriorWeb::Task.new
        task.should_not_receive(:save!)
        TaskwarriorWeb::Task.should_receive(:new).once.and_return(task)
        post '/tasks', :task => {}
      end

      it 'should render the task form' do
        task = TaskwarriorWeb::Task.new({:tags => 'tag1, tag2'})
        allow(TaskwarriorWeb::Task).to receive(:new).and_return(task)
        post '/tasks', :task => {}
        last_response.body.should have_tag('form') do
          with_tag('input', :with => { :name => 'task[tags]' , :value => 'tag1, tag2' })
        end
      end

      it 'should display errors messages' do
        task = TaskwarriorWeb::Task.new
        allow(TaskwarriorWeb::Task).to receive(:new).and_return(task)
        post '/tasks', :task => {}
        last_response.body.should have_tag('.alert-error')
      end
    end
  end

  describe 'GET /tasks/:uuid' do
    context 'given a non-existant task' do
      it 'should return a 404' do
        TaskwarriorWeb::Task.should_receive(:find).and_return(nil)
        get '/tasks/1'
        last_response.should be_not_found
      end
    end

    context 'given an existing task' do
      before do
        TaskwarriorWeb::Task.should_receive(:find).and_return(
          TaskwarriorWeb::Task.new({:uuid => 246, :description => 'Test task with a longer description'})
        )
        get '/tasks/246'
      end

      it 'should render an edit form' do
        last_response.body.should have_tag('form', :with => { :action => '/tasks/246', :method => 'post' }) do
          with_tag('input', :with => { :name => '_method', :value => 'patch' })
        end
      end

      it 'should set the HTTP method in the form' do
      end

      it 'should truncate the task description' do
        last_response.body.should have_tag('title', :text => /Test task with a .../)
      end

      it 'should fill the form fields with existing data' do
        last_response.body.should have_tag('input', :with => { :name => 'task[description]', :value => 'Test task with a longer description' })
      end
    end
  end

  describe 'PATCH /tasks/:uuid' do
    context 'given a non-existant task' do
      it 'should return a 404' do
        TaskwarriorWeb::Task.should_receive(:find).and_return(nil)
        patch '/tasks/429897527'
        last_response.should be_not_found
      end
    end

    context 'given an existing task' do
      before do
        TaskwarriorWeb::Task.should_receive(:find).and_return('hello')
      end

      it 'should render an error message if the task is invalid' do
        patch '/tasks/23455', :task => { :tags => 'test, tags' }
        last_response.body.should have_tag('form')
        last_response.body.should have_tag('#flash-messages') do
          with_tag('.alert-error', :text => /description/)
        end
      end

      it 'should save the task and redirect if the task is valid' do
        task = TaskwarriorWeb::Task.new({ :description => 'Test task' })
        task.should_receive(:is_valid?).and_return(true)
        task.should_receive(:save!).once.and_return('A message!')
        TaskwarriorWeb::Task.should_receive(:new).and_return(task)
        patch '/tasks/2356', :task => { :description => 'Test task' }
        last_response.should be_redirect
        follow_redirect!
        last_request.url.should =~ /\/tasks\/?$/
      end
    end
  end

  describe 'DELETE /tasks/:uuid' do
    context 'given a non-existant task' do
      it 'should return a 404' do
        allow(TaskwarriorWeb::Task).to receive(:find).and_return(nil)
        delete '/tasks/429897527'
        last_response.should be_not_found
      end
    end

    context 'given an existing task' do
      before do
        @task = TaskwarriorWeb::Task.new
        @task.should_receive(:delete!).once.and_return('Success')
        TaskwarriorWeb::Task.should_receive(:find).and_return(@task)
        delete '/tasks/246'
      end

      it 'should redirect to the task overview page' do
        follow_redirect!
        last_request.url.should match(/tasks$/)
      end
    end
  end

  describe 'GET /projects' do
    it 'should redirect to /projects/overview' do
      get '/projects'
      follow_redirect!

      last_request.url.should match(/projects\/overview$/)
      last_response.should be_ok
    end
  end

  describe 'GET /projects/:name' do
    it 'should replace characters in the title' do
      allow(TaskwarriorWeb::Task).to receive(:query).and_return([])
      get '/projects/Test--Project'
      last_response.body.should include('<title>Test.Project')
    end
  end

  describe 'GET /ajax/projects' do
    it 'should return a list of projects as JSON' do
      command = TaskwarriorWeb::Command.new(:projects)
      command.should_receive(:run).and_return("Project One\nProject Two")
      TaskwarriorWeb::Command.should_receive(:new).with(:projects).and_return(command)
      get '/ajax/projects'
      last_response.body.should eq(['Project One', 'Project Two'].to_json)
    end
  end

  describe 'GET /ajax/count' do
    it 'should return the current pending task count' do
      TaskwarriorWeb::Task.should_receive(:count).and_return(15)
      get '/ajax/count'
      last_response.body.should eq('15')
    end
  end

  describe 'POST /ajax/task-complete/:id' do
    it 'should mark the given task as complete' do
      command = TaskwarriorWeb::Command.new(:complete, 15)
      command.should_receive(:run).once
      TaskwarriorWeb::Command.should_receive(:new).once.with(:complete, '15').and_return(command)
      post '/ajax/task-complete/15'
      last_response.should be_ok
    end
  end

  describe 'GET /ajax/badge' do
    context 'given a filter specified in .taskrc' do
      before do
        TaskwarriorWeb::Config.should_receive(:property).with('task-web.filter.badge').and_return('a filter')
      end

      it 'should get the count by runnng the filter' do
        TaskwarriorWeb::Task.should_receive(:query).once.with('a filter').and_return([])
        get '/ajax/badge'
      end
    end

    it 'should return the count as a string' do
      TaskwarriorWeb::Config.should_receive(:property).with('task-web.filter.badge').and_return('a filter')
      TaskwarriorWeb::Task.should_receive(:query).with('a filter').and_return(['test'])
      get '/ajax/badge'
      last_response.body.should eq('1')
      last_response.body.should be_a(String)
    end

    it 'should return an empty string if the count is zero' do
      TaskwarriorWeb::Config.should_receive(:property).with('task-web.filter.badge').and_return('a filter')
      TaskwarriorWeb::Task.should_receive(:query).with('a filter').and_return([])
      get '/ajax/badge'
      last_response.body.should eq('')
    end
  end

  describe 'not_found' do
    it 'should set the title to "Not Found"' do
      get '/page-not-found'
      last_response.body.should include('<title>Page Not Found')
    end

    it 'should have a status code of 404' do
      get '/page-not-found'
      last_response.should be_not_found
    end
  end

end

describe 'HTTP authentication' do
  include Rack::Test::Methods

  def app
    TaskwarriorWeb::App
  end

  before do
    allow(TaskwarriorWeb::Config).to receive(:property).with('task-web.filter').and_return(nil)
    allow(TaskwarriorWeb::Runner).to receive(:run).and_return('{}')
  end

  context 'when credentials are specified in .taskrc' do
    before do
      allow(TaskwarriorWeb::Config).to receive(:property).with('task-web.user').and_return('test_user')
      allow(TaskwarriorWeb::Config).to receive(:property).with('task-web.passwd').and_return('test_pass')
    end

    it 'should ask for authentication' do
      get '/tasks/new'
      last_response.should be_client_error
    end

    it 'should only accept the configured credentials' do
      authorize 'bad', 'user'
      get '/tasks/new'
      last_response.should be_client_error
    end

    it 'should pass when the correct credentials are given' do
      authorize 'test_user', 'test_pass'
      get '/tasks/new'
      last_response.should be_ok
    end
  end

  context 'when no credentials are specified in .taskrc' do
    before do
      allow(TaskwarriorWeb::Config).to receive(:property).with('task-web.user').and_return(nil)
    end

    it 'should bypass authentication' do
      get '/tasks/new'
      last_response.should be_ok
    end
  end
end
