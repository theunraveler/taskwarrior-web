module TaskwarriorWeb::CommandBuilder
  autoload :Base, 'taskwarrior-web/services/builder/base'
  autoload :V1,   'taskwarrior-web/services/builder/v1'
  autoload :V2,   'taskwarrior-web/services/builder/v2'

  class InvalidCommandError < Exception; end
  class MissingTaskIDError < Exception; end

  def self.included(class_name)
    class_name.class_eval do
      case TaskwarriorWeb::Config.version.major
      when 2
        include TaskwarriorWeb::CommandBuilder::V2
      when 1
        include TaskwarriorWeb::CommandBuilder::V1
      else
        raise TaskwarriorWeb::UnrecognizedTaskVersion
      end
    end
  end

end
