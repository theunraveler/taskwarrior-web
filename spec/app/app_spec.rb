require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/app'

set :environment, :test

describe "My App" do
  include Rack::Test::Methods

  def app
    TaskwarriorWeb::App
  end

  before do
    TaskwarriorWeb::Config.should_receive(:file).any_number_of_times.and_return(ParseConfig.new)
    TaskwarriorWeb::Runner.should_receive(:run).any_number_of_times.and_return('{}')
  end

  describe 'GET /' do
    it 'should redirect to /tasks/pending' do
      get "/"
      follow_redirect!

      last_request.url.should =~ /tasks\/pending/
      last_response.should be_ok
    end
  end
end
