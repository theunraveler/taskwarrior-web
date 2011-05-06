$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'

require 'taskwarrior-web/app'
require 'taskwarrior-web/task'
require 'taskwarrior-web/config'
