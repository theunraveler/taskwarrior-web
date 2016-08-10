require 'shellwords'

module TaskwarriorWeb::CommandBuilder::Base

  TASK_COMMANDS = {
    :add => 'add',
    :update => TaskwarriorWeb::Config.version.major >= 2 ? ':id mod' : nil,
    :delete => 'rc.confirmation=no :id delete',
    :query => TaskwarriorWeb::Config.version == '1.9.4' ? '_query' : 'export',
    :complete => ':id done',
    :annotate => ':id annotate',
    :denotate => ':id denotate',
    :projects => '_projects',
    :tags => '_tags',
    :sync => 'sync'
  }

  def build
    unless @command_string
      task_command
      substitute_parts if @command_string =~ /:id/
    end
    parse_params
    @built = "#{@command_string}#{@params}"
  end

  def task_command
    if TASK_COMMANDS[@command.to_sym]
      @command_string = TASK_COMMANDS[@command.to_sym].clone
      return self
    else
      raise TaskwarriorWeb::CommandBuilder::InvalidCommandError
    end
  end

  def substitute_parts
    if @id
      @command_string.gsub!(':id', "uuid:#{@id.to_s}")
      return self
    end
    raise TaskwarriorWeb::CommandBuilder::MissingTaskIDError
  end

  def parse_params
    string = ''
    string << %( #{@params.delete(:description).shellescape}) if @params.has_key?(:description)

    if tags = @params.delete(:tags)
      tag_indicator = TaskwarriorWeb::Config.property('tag.indicator') || '+'
      tags.each { |tag| string << %( #{tag_indicator}#{tag.to_s.shellescape}) }
    end

    if tags = @params.delete(:remove_tags)
      tags.each { |tag| string << %( -#{tag.to_s.shellescape}) } 
    end

    @params.each do |attr, value|
      if @command != :update or attr != :uuid
        if value.respond_to? :each
          value.each { |val| string << %( #{attr.to_s}:\\"#{val.to_s.shellescape}\\") }
        else
          string << %( #{attr.to_s}:\\"#{value.to_s.shellescape}\\")
        end
      end
    end

    @params = string
    return self
  end

end
