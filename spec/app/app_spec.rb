require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/app'

set :environment, :test

describe "My App" do
  include Rack::Test::Methods

  def app
    TaskwarriorWeb::App
  end

  before do
    TaskwarriorWeb::Config.should_receive(:property).with('task-web.user').any_number_of_times.and_return(nil)
    TaskwarriorWeb::Runner.should_receive(:run).any_number_of_times.and_return('{}')
  end

  ['/', '/tasks'].each do |path|
    describe "GET #{path}" do
      it 'should redirect to /tasks/pending' do
        get path
        follow_redirect!

        last_request.url.should =~ /tasks\/pending/
        last_response.should be_ok
      end
    end
  end

  describe 'GET /projects' do
    it 'should redirect to /projects/overview' do
      get '/projects'
      follow_redirect!

      last_request.url.should =~ /projects\/overview/
      last_response.should be_ok
    end
  end

  describe 'GET /ajax/count' do
    it 'should return the current pending task count' do
      TaskwarriorWeb::Task.should_receive(:count).and_return(15)
      get '/ajax/count'
      last_response.body.should eq('15')
    end
  end
end
