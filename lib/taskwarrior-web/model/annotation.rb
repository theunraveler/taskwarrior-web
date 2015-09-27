module TaskwarriorWeb

  class Annotation < Hash
    attr_accessor :_errors

    def initialize(attributes = {})
      self.merge!(attributes.select { |s| self.respond_to? s.to_sym })
      @_errors = []
    end

    def description
      self[:description]
    end

    def entry
      self[:entry]
    end

    def task_id
      self[:task_id]
    end

    def save!
      gen_cmd(:annotate).run
    end

    def delete!
      gen_cmd(:denotate).run
    end

    def is_valid?
      @_errors << 'You must provide a description' if self[:description].blank?
      @_errors.empty?
    end

    private

    def gen_cmd cmd
      Command.new(cmd, self[:task_id], { :description => self[:description] })
    end

  end

end
