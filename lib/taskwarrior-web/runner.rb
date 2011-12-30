module TaskwarriorWeb
  class Runner

    TASK_BIN = 'task'

    def self.run(command)
      command = TASK_BIN + " #{command}"
      `#{command}`
    end

  end
end
