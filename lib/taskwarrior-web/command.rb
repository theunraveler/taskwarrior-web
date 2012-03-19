require 'taskwarrior-web/command_builder'
require 'taskwarrior-web/runner'

module TaskwarriorWeb
  class Command

    include TaskwarriorWeb::CommandBuilder
    include TaskwarriorWeb::Runner

    attr_accessor :command, :id, :params, :built, :command_string

    def initialize(command, id = nil, *args)
      @command = command if command
      @id = id if id
      puts "@id in command.rb: #{@id}"
      @params = args.last.is_a?(::Hash) ? args.pop : {}
    end

  end
end
