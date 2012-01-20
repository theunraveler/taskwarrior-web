# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch('Gemfile')
  watch('taskwarrior-web.gemspec')
end

guard 'rspec', :version => 2 do
  watch(/^lib\/(.+)\.rb$/) { "spec" }
  watch(/^spec\/(.+)\.rb$/) { "spec" }
end
