module TaskwarriorWeb::Runner
  TASK_BIN = 'task'

  def run
    @built ||= build
    `#{TASK_BIN} #{@built}`
  end
end
