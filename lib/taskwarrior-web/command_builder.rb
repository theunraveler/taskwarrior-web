require 'taskwarrior-web/config'

module TaskwarriorWeb
  module CommandBuilder
    def self.included(class_name)
      class_name.class_eval do
        case TaskwarriorWeb::Config.task_version
        when /^2/
          require 'taskwarrior-web/command_builders/v2'
          include TaskwarriorWeb::CommandBuilder::V2
        when /^1/
          require 'taskwarrior-web/command_builders/v1'
          include TaskwarriorWeb::CommandBuilder::V1
        else
          raise TaskwarriorWeb::UnrecognizedTaskVersion
        end
      end
    end
  end

  class UnrecognizedTaskVersion < Exception; end
end
