require 'taskwarrior-web/command_builders/base'

module TaskwarriorWeb::CommandBuilder
  module V1

    include TaskwarriorWeb::CommandBuilder::Base
      
    # Overridden from TaskwarriorWeb::CommandBuilder::Base
    #
    # Substitute the task's ID for its UUID.
    def substitute_parts
      if @id
        assign_id_from_uuid
        puts @id
        @command_string.gsub!(':id', @id.to_s)
        return self
      else
        raise MissingTaskIDError
      end
    end

    def assign_id_from_uuid
      @all_tasks ||= Task.query('status.not' => [:deleted, :completed])
      @id = @all_tasks.select { |task| task.uuid == self.id }
    end

  end
end
