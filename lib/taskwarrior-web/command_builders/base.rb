module TaskwarriorWeb::CommandBuilder
  module Base

    TASK_COMMANDS = {
      :add => 'add',
      :query => '_query',
      :count => 'count',
      :complete => ':id done'
    }    

    def build
      unless @command_string
        task_command
        substitute_parts if @command_string =~ /:id/
      end
      parse_params
      @built = "#{self.command_string}#{params}"
    end

    def task_command
      if TASK_COMMANDS.has_key?(@command.to_sym)
        @command_string = TASK_COMMANDS[@command.to_sym]
        return self
      else
        raise InvalidCommandError
      end
    end

    def substitute_parts
      if @id
        @command_string.gsub!(':id', "uuid:#{@id.to_s}")
        return self
      else
        raise TaskwarriorWeb::CommandBuilder::MissingTaskIDError
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

      @params.each do |attr, value|
        if value.respond_to? :each
          value.each { |val| string << " #{attr.to_s}:#{val.to_s}" }
        else
          string << " #{attr.to_s}:#{value.to_s}"
        end
      end

      @params = string
      return self
    end

  end

  class InvalidCommandError < Exception; end
  class MissingTaskIDError < Exception; end
end
