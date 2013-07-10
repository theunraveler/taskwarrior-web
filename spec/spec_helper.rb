require 'sinatra'
require 'rack/test'
require 'rspec'
require 'simple_navigation'
require 'rspec-html-matchers'

# Simplecov
require 'simplecov'
SimpleCov.start do
  add_filter "spec"
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end

SimpleNavigation.config_file_paths << File.dirname(__FILE__) + '/../lib/taskwarrior-web/config'
