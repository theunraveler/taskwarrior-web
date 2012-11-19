$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'

module TaskwarriorWeb
  autoload :App,            'taskwarrior-web/app'
  autoload :Helpers,        'taskwarrior-web/helpers'
  autoload :Task,           'taskwarrior-web/task'
  autoload :Config,         'taskwarrior-web/config'
  autoload :Command,        'taskwarrior-web/command'
  autoload :CommandBuilder, 'taskwarrior-web/services/builder'
  autoload :Runner,         'taskwarrior-web/services/runner'
  autoload :Parser,         'taskwarrior-web/services/parser'

  class UnrecognizedTaskVersion < Exception; end
end
