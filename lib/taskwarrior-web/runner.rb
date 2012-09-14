require 'taskwarrior-web/config'

module TaskwarriorWeb
  module Runner

    TASK_BIN = 'task'

    def run
      @built ||= build
      `#{TASK_BIN} #{@built}`
    end

  end
end
