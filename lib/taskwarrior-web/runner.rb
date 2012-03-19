require 'taskwarrior-web/config'

module TaskwarriorWeb
  module Runner

    TASK_BIN = 'task'

    def run
      @built ||= build
      to_run = "#{TASK_BIN} #{@built}"
      puts "Final command: #{to_run}"
      `#{to_run}`
    end

  end
end
