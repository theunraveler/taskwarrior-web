# taskwarrior.rb
require "rubygems"
require "bundler/setup"
require 'sinatra'
require 'erb'
require 'parseconfig'
require 'json'

# Require all model files
Dir['./models/*.rb'].each do |file|
  require file
end

# Before filter
before do
  @current_page = request.path_info
end

# Root
get '/' do
  redirect '/pending'
end

# Task routes
get '/pending/?' do
  @title = 'Pending Tasks'
  @tasks = Taskwarrior::Task.tasks
  erb :index  
end

get '/completed' do
  @title = 'Completed Tasks'
  @tasks = Taskwarrior::Task.tasks('completed')
  erb :index  
end

# Projects
get '/projects' do

end

get 'projects/:name/tasks' do

end

# Reporting
get '/reports' do

end
