module TaskwarriorWeb
  class Runner

    TASK_BIN = 'task'

    TASK_COMMANDS = {
      'complete' => ':id done',
      'add' => 'add',
      'delete' => ':id rm',
      'query' => '_query'
    }

    def self.run(command)
      stdout = TASK_BIN + " #{command}"
      `#{stdout}`
    end

    def self.parse_args(*args)
      String.new.tap do |string|
        args = args.last.is_a?(::Hash) ? args.pop : {}
        args.each do |attr, value|
          string << " #{attr.to_s}:#{value.to_s}"
        end
      end
    end

  end
end
