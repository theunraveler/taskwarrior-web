module Taskwarrior

  ###########################################
  # UTILITY CLASS FOR DYNAMIC FINDER MATCHING
  ###########################################
  class TaskDynamicFinderMatch

    attr_accessor :attribute

    def initialize(method_sym)
      if method_sym.to_s =~ /^find_by_(.*)$/
        @attribute = $1
      end
    end
    
    def match?
      @attribute != nil
    end

  end
  
  #################
  # MAIN TASK CLASS
  #################
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

    # Run queries on tasks.
    def self.query(*args)
      tasks = []
  
      stdout = 'task _query'
      args.each do |param|
        param.each do |attr, value|
          stdout << " | grep '\"#{attr}\":\"#{value}\"'"
        end
      end

      # Process the JSON data.
      json = `#{stdout}`
      json.strip!
      json.chop! unless json.match(/[.*]?}$/)
      json = '[' + json + ']'
      raw = JSON.parse(json)

      raw.each do |line|
        tasks << Task.new(line)
      end
      return tasks
    end

    # Define method_missing to implement dynamic finder methods
    def self.method_missing(method_sym, *arguments, &block)
      match = TaskDynamicFinderMatch.new(method_sym)
      if match.match? 
        self.query(match.attribute => arguments.first)
      else
        super
      end
    end
    
    # Implement respond_to? so that our dynamic finders are declared
    def self.respond_to?(method_sym, include_private = false)
      if TaskDynamicFinderMatch.new(method_sym).match?
        true
      else
        super
      end
    end

  end
end
