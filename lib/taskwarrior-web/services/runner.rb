module TaskwarriorWeb::Runner
  TASK_BIN = 'task rc.xterm.title=no rc.color=off rc.verbose=no'

  def run
    @built ||= build
    `#{TASK_BIN} #{@built}`
  end
end
