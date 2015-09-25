module TaskwarriorWeb::Runner
  TASK_BIN = 'task rc.xterm.title=no rc.color=off rc.verbose=no rc.confirmation=no'

  def run
    @built ||= build
    puts "> #{TASK_BIN} #{@built}"
    `#{TASK_BIN} #{@built}`
  end
end
