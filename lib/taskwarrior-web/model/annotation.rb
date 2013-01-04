module TaskwarriorWeb
  class Annotation
    attr_accessor :task_id, :entry, :description, :_errors

    def initialize(attributes = {})
      attributes.each do |attr, value|
        send("#{attr}=", value) if respond_to?(attr.to_sym)
      end

      @_errors = []
    end

    def save!
      Command.new(:annotate, self.task_id, { :description => self.description }).run
    end

    def delete!
      Command.new(:denotate, self.task_id, { :description => self.description }).run
    end

    def is_valid?
      @_errors << 'You must provide a description' if self.description.blank?
      @_errors.empty?
    end
  end
end
