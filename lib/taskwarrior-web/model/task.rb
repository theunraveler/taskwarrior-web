module TaskwarriorWeb
  
  #################
  # MAIN TASK CLASS
  #################
  class Task

    attr_accessor :entry, :project, :priority, :uuid, :description, :status,
                  :due, :start, :end, :tags, :depends, :wait, :annotations, :recur,
                  :urgency, :_errors, :remove_tags

    ####################################
    # MODEL METHODS FOR INDIVIDUAL TASKS
    ####################################

    def initialize(attributes = {})
      attributes.each do |attr, value|
        send("#{attr}=", value) if respond_to?(attr.to_sym)
      end

      @_errors = []
      @tags = [] if @tags.nil?
      @annotations = [] if @annotations.nil?
    end

    def save!
      @uuid ? Command.new(:update, uuid, self.to_hash).run : Command.new(:add, nil, self.to_hash).run
    end

    def complete!
      Command.new(:complete, self.uuid).run
    end

    def delete!
      Command.new(:delete, self.uuid).run
    end

    # Make sure that the tags are an array.
    def tags=(value)
      @tags = value.is_a?(String) ? value.split(/[, ]+/).reject(&:empty?) : value

      if @uuid
        @remove_tags = Task.find_by_uuid(uuid).first.tags - @tags
      end
    end

    # Create annotation instances.
    def annotations=(annotations)
      @annotations = []
      annotations.each do |annotation|
        annotation.merge({ :task_id => self.uuid })
        @annotations << Annotation.new(annotation)
      end
    end

    def is_valid?
      @_errors << 'You must provide a description' if self.description.blank?
      @_errors.empty?
    end

    def active?
      status.in? ['pending', 'waiting']
    end

    def to_hash
      Hash[instance_variables.select { |var| !var.to_s.start_with?('@_') }.map { |var| [var[1..-1].to_sym, instance_variable_get(var)] }]
    end

    def to_s
      description.truncate(20)
    end
    
    ##################################
    # CLASS METHODS FOR QUERYING TASKS
    ##################################

    ##
    # Get a single task by UUID or ID. Returns nil if no such task was found.

    def self.find(uuid)
      tasks = Parser.parse(Command.new(:query, nil, :uuid => uuid).run)
      tasks.empty? ? nil : Task.new(tasks.first)
    end

    ##
    # Whether or not a given task exists. Basically sugar for Task.find, but
    # returns a boolean instead of the actual task.

    def self.exists?(uuid)
      !!self.find(uuid)
    end

    ##
    # Run queries, returns an array of tasks that meet the criteria.
    #
    # Filters can either be a hash of conditions, or an already-constructed
    # taskwarrior filter string.
    #
    # For example:
    # { :description => 'test', 'project.not' => '' }
    # 'description:test project.not:'

    def self.query(*args)
      tasks = []
      if !args.empty? && args.first.is_a?(String)
        command = Command.new(:query, nil, :description => args.first)
      else
        command = Command.new(:query, nil, *args)
      end
      Parser.parse(command.run).each { |result| tasks << Task.new(result) }
      tasks
    end

    ##
    # Get the number of tasks for some paramters.
    def self.count(*args)
      self.query(*args).count
    end

    # Define method_missing to implement dynamic finder methods
    def self.method_missing(method_sym, *arguments, &block)
      match = TaskDynamicFinderMatch.new(method_sym)
      if match.match? 
        self.query(match.attribute.to_s => arguments.first.to_s)
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
end
