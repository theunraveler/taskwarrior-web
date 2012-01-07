module TaskwarriorWeb
  class Command

    attr_accessor :command, :id, :params

    def initialize(command, id = nil, *args)
      if command
        @command = command
      else
        raise TaskwarriorWeb::MissingCommandError
      end

      @id = id if id
      @params = args.last.is_a?(::Hash) ? args.pop : {}
    end

    def run
      TaskwarriorWeb::Runner.run(self)
    end

    private

    def parse_params
      String.new.tap do |string|
        @params.each { |attr, value| string << " #{attr.to_s}:#{value.to_s}" }
      end
    end

  end

  class MissingCommandError < Exception; end
end
