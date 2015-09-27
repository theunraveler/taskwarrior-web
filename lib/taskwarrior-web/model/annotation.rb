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
      gen_cmd(:annotate).run
    end

    def delete!
      gen_cmd(:denotate).run
    end

    def is_valid?
      @_errors << 'You must provide a description' if self.description.blank?
      @_errors.empty?
    end

    private

    def gen_cmd cmd
      Command.new(cmd, self.task_id, { :description => self.description })
    end

  end
end
