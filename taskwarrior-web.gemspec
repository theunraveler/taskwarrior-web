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
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "taskwarrior-web"

  s.add_dependancy('sinatra')
  s.add_dependancy('parseconfig')
  s.add_dependancy('vegas')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
