module Taskwarrior

# A class to get a list of tasks
class Task

  ####################################
  # MODEL METHODS FOR INDIVIDUAL TASKS
  ####################################
  
  def save!
  end

  ##################################
  # CLASS METHODS FOR QUERYING TASKS
  ##################################

  # Janky singleton to get the task directory.
  def self.directory
    if @directory
      @directory
    else
      taskrc = ParseConfig.new("#{Dir.home}/.taskrc")
      @directory = taskrc.get_value('data.location')
    end
  end

  # Get all tasks, limited by task state
  # Possible values: "pending", "completed", "deleted"
  def self.tasks(state = "pending")
    directory = self.directory
  end

end

end
