# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "taskwarrior-web"
  s.version     = '1.1.2'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jake Bell"]
  s.email       = ["jake@theunraveler.com"]
  s.homepage    = "http://github.com/theunraveler/taskwarrior-web"
  s.summary     = %q{Web frontend for taskwarrior command line task manager.}
  s.description = %q{This gem provides a graphical frontend for the Taskwarrior task manager. It is based on Sinatra.}

  s.rubyforge_project = "taskwarrior-web"

  s.required_ruby_version = '>= 1.9.0'

  s.add_dependency('sinatra')
  s.add_dependency('parseconfig')
  s.add_dependency('vegas')
  s.add_dependency('rinku')
  s.add_dependency('versionomy')
  s.add_dependency('activesupport')
  s.add_dependency('sinatra-simple-navigation')
  s.add_dependency('rack-flash3')

  s.add_development_dependency('rake')
  s.add_development_dependency('rack-test')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-html-matchers')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
