# taskwarrior.rb
require "rubygems"
require "bundler/setup"
require 'sinatra'
require 'erb'
require 'parseconfig'

# Require all model files
Dir['./models/*.rb'].each do |file|
  require file
end

# Root
get '/' do
  redirect '/pending'
end

# Task routes
get '/pending/?' do
  @title = 'Pending Tasks'
  @task_dir = Taskwarrior::Task.directory
  erb :index  
end

get '/completed' do

end

# Projects
get '/projects' do

end

get 'projects/:name/tasks' do

end

# Reporting
get '/reports' do

end
