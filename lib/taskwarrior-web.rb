$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/string/filters'

module TaskwarriorWeb
  autoload :App,            'taskwarrior-web/app'
  autoload :Helpers,        'taskwarrior-web/helpers'
  autoload :Task,           'taskwarrior-web/model/task'
  autoload :Config,         'taskwarrior-web/model/config'
  autoload :Command,        'taskwarrior-web/model/command'
  autoload :CommandBuilder, 'taskwarrior-web/services/builder'
  autoload :Runner,         'taskwarrior-web/services/runner'
  autoload :Parser,         'taskwarrior-web/services/parser'

  VERSION = '1.1.4'

  class UnrecognizedTaskVersion < Exception; end
end
