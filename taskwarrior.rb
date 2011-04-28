# taskwarrior.rb
require "rubygems"
require "bundler/setup"
require 'sinatra'
require 'erb'
require 'parseconfig'

# Root
get '/' do
  redirect '/tasks/pending'
end

# Task routes
get '/tasks/pending' do
  @title = 'Pending Tasks'
  taskrc = ParseConfig.new("#{Dir.home}/.taskrc")
  @task_dir = taskrc.get_value('data.location')
  erb :index  
end

get '/tasks/completed' do

end
