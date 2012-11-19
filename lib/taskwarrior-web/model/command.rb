class TaskwarriorWeb::Command
  include TaskwarriorWeb::CommandBuilder
  include TaskwarriorWeb::Runner

  attr_accessor :command, :id, :params, :built, :command_string

  def initialize(command, id = nil, *args)
    @command = command if command
    @id = id if id
    @params = args.last.is_a?(::Hash) ? args.pop : {}
  end
end
