# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "taskwarrior-web/version"

Gem::Specification.new do |s|
  s.name        = "taskwarrior-web"
  s.version     = TaskwarriorWeb::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jake Bell"]
  s.email       = ["jake@theunraveler.com"]
  s.homepage    = "http://taskwarrior.org"
  s.summary     = %q{Web frontend for taskwarrior command line task manager.}
  s.description = %q{This gem provides a graphical frontend for the Taskwarrior task manager. It is based on Sinatra.}

  s.rubyforge_project = "taskwarrior-web"

  s.add_dependency('sinatra')
  s.add_dependency('parseconfig')
  s.add_dependency('vegas')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('simplecov')
  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('guard-bundler')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
