require File.join(File.dirname(__FILE__), 'lib', 'taskwarrior-web')
require 'sinatra'

disable :run
TaskwarriorWeb::App.set({ :environment => :production })

map '/' do
  run TaskwarriorWeb::App
end
