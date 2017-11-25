require File.join(File.dirname(__FILE__), 'lib', 'taskwarrior-web')

TaskwarriorWeb::App.set({ :environment => :production })
run TaskwarriorWeb::App
