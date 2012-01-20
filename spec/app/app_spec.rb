require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/app'

set :environment, :test

describe "My App" do
  include Rack::Test::Methods

  def app
    TaskwarriorWeb::App
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
