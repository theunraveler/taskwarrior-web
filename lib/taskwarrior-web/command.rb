require 'taskwarrior-web/runner'

module TaskwarriorWeb
  class Command

    include CommandBuilder
    include Runner

    attr_accessor :command, :id, :params

    def initialize(command, id = nil, *args)
      @command = command if command
      @id = id if id
      @params = args.last.is_a?(::Hash) ? args.pop : {}
    end

  end
end
