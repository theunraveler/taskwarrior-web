require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec)

desc 'Uninstalls the current version of taskwarrior-web'
task :uninstall do
  `gem uninstall -x taskwarrior-web`
end

desc 'Reloads the gem (useful for local development)'
task :refresh => [:uninstall, :install] do
  `task-web -F`
end
