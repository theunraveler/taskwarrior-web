$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'

module TaskwarriorWeb
  autoload :App,            'taskwarrior-web/app'
  autoload :Helpers,        'taskwarrior-web/helpers'
  autoload :Task,           'taskwarrior-web/task'
  autoload :Config,         'taskwarrior-web/config'
  autoload :CommandBuilder, 'taskwarrior-web/command_builder'
  autoload :Command,        'taskwarrior-web/command'
  autoload :Runner,         'taskwarrior-web/runner'
  autoload :Parser,         'taskwarrior-web/parser'

  class UnrecognizedTaskVersion < Exception; end
end
