module Taskwarrior
  # A class to get a list of tasks
  class Task

    attr_accessor :project, :uuid

    ####################################
    # MODEL METHODS FOR INDIVIDUAL TASKS
    ####################################

    def save!
    end

    ##################################
    # CLASS METHODS FOR QUERYING TASKS
    ##################################

    # Get the task directory.
    def self.directory
      Taskwarrior::Config.file.get_value('data.location')
    end

    # Get all tasks, limited by task state
    # Possible values: "pending", "completed", "deleted"
    def self.tasks(state = "pending")
      filename = "#{self.directory}/#{state}.data".gsub('~', Dir.home)
      file = File.new(filename, 'r')
      out = []
  
      file.each_line("\n") do |row|
        # Ugly, ugly, ugly.
        row.gsub!('[', '{"').gsub!(']', '}').gsub!(':', '":').gsub!('" ', '","')
        out << JSON.parse(row).to_s
      end
      return out
    end

  end
end
