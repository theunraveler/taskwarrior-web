module TaskwarriorWeb
  class Runner

    TASK_BIN = 'task'

    TASK_COMMANDS = {
      :complete => ':id done',
      :add => 'add',
      :delete => ':id rm',
      :query => '_query'
    }

    def self.run(command_obj)
      command = task_command(command_obj)
      command = substitute_parts(command, command_obj) if command =~ /:id/
      params = parsed_params(command_obj)
      stdout = "#{TASK_BIN} #{command}#{params}"
      `#{stdout}`
    end

    def self.task_command(command_obj)
      if TASK_COMMANDS.has_key?(command_obj.command.to_sym)
        TASK_COMMANDS[command_obj.command.to_sym]
      else
        raise InvalidCommandError
      end
    end

    def self.substitute_parts(task_command, command_obj)
      if command_obj.id
        task_command.gsub(':id', command_obj.id.to_s)
      else
        raise MissingTaskIDError
      end
    end

    def self.parsed_params(command_obj)
      String.new.tap do |string|
        string << " '#{command_obj.params.delete(:description)}'" if command_obj.params.has_key?(:description)

        if command_obj.params.has_key?(:tags)
          tags = command_obj.params.delete(:tags)
          tags.each { |tag| string << " +#{tag.to_s}" } 
        end

        command_obj.params.each { |attr, value| string << " #{attr.to_s}:#{value.to_s}" }
      end
    end


  end

  class InvalidCommandError < Exception; end
  class MissingTaskIDError < Exception; end
end
