module TaskwarriorWeb
  class Runner

    TASK_BIN = 'task'

    TASK_COMMANDS = {
      'complete' => ':id done',
      'add' => 'add',
      'delete' => ':id rm',
      'query' => '_query'
    }

    def self.run(command, *params)
      command = TASK_BIN + " #{command}"
      `#{command}`
    end

    def self.parse_args(*args)
      String.new.tap do |string|
        args.each do |param|
          param.each do |attr, value|
            string << " #{attr.to_s}:#{value.to_s}"
          end
        end
      end
    end

  end
end
