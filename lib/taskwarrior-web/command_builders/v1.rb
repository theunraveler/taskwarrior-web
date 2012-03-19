require 'taskwarrior-web/command_builders/base'

module TaskwarriorWeb::CommandBuilder
  module V1

    include TaskwarriorWeb::CommandBuilder::Base
      
    # Overridden from TaskwarriorWeb::CommandBuilder::Base
    #
    # Substitute the task's ID for its UUID.
    def substitute_parts
      assign_id_from_uuid if @id
      super
    end

    def assign_id_from_uuid
      @all_tasks ||= TaskwarriorWeb::Task.query('status.not' => [:deleted, :completed])
      @id = @all_tasks.index { |task| task.uuid == @id } + 1
      puts "@id in v1.rb:19: #{@id}"
    end

  end
end
