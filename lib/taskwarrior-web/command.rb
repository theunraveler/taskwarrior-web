require 'taskwarrior-web/runner'

module TaskwarriorWeb
  class Command

    attr_accessor :command, :id, :params

    def initialize(command, id = nil, *args)
      @command = command if command
      @id = id if id
      @params = args.last.is_a?(::Hash) ? args.pop : {}
    end

    def run
      if @command
        TaskwarriorWeb::Runner.run(self)
      else
        raise MissingCommandError
      end
    end

  end

  class MissingCommandError < Exception; end
end
