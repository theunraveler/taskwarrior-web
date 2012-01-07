require 'rspec'

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
  config.include(RSpec::Mocks::Methods)
end
