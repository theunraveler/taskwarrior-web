require 'taskwarrior-web/config'

module TaskwarriorWeb
  module CommandBuilder
    def self.included(class_name)
      class_name.class_eval do
        case TaskwarriorWeb::Config.task_major_version
        when 2
          require 'taskwarrior-web/command_builders/v2'
          include TaskwarriorWeb::CommandBuilder::V2
        when 1
          require 'taskwarrior-web/command_builders/v1'
          include TaskwarriorWeb::CommandBuilder::V1
        else
          raise TaskwarriorWeb::UnrecognizedTaskVersion
        end
      end
    end

    attr_accessor :built

    TASK_COMMANDS = {
      :add => 'add',
      :query => '_query',
      :count => 'count',
      :complete => ':id done'
    }    

    def build
      task_command
      substitute_parts if command =~ /:id/
      parse_params
      @built = "#{self.task_command}#{params}"
    end

    def task_command
      if TASK_COMMANDS.has_key?(@command.to_sym)
        @command = TASK_COMMANDS[@command.to_sym]
        self
      else
        raise InvalidCommandError
      end
    end

    def substitute_parts
      if self.id
        @command.gsub!(':id', @id.to_s)
        self
      else
        raise MissingTaskIDError
      end
    end

    def parse_params
      string = ''
      string << " '#{@params.delete(:description)}'" if @params.has_key?(:description)

      if @params.has_key?(:tags)
        tags = @params.delete(:tags)
        tag_indicator = TaskwarriorWeb::Config.property('tag.indicator') || '+'
        tags.each { |tag| string << " #{tag_indicator}#{tag.to_s}" } 
      end

      @params.each { |attr, value| string << " #{attr.to_s}:#{value.to_s}" }
      @params = string
      self
    end

  end


  class UnrecognizedTaskVersion < Exception; end
end
