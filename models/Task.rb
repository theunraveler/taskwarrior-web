module Taskwarrior
  class Task

    attr_accessor :entry, :project, :uuid, :description, :status, :due, :start, :end, :tags

    ####################################
    # MODEL METHODS FOR INDIVIDUAL TASKS
    ####################################

    def initialize(attributes = {})
      attributes.each do |attr, value|
        send("#{attr}=", value)  
      end  
    end

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
        out << Task.new(JSON.parse(row))
      end
      return out
    end

  end
end
