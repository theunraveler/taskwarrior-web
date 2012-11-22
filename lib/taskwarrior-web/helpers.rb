module TaskwarriorWeb::App::Helpers

  def format_date(timestamp)
    format = TaskwarriorWeb::Config.dateformat || '%-m/%-d/%Y'
    Time.parse(timestamp).strftime(format)
  end

  def colorize_date(timestamp)
    return if timestamp.nil?
    due_def = (TaskwarriorWeb::Config.due || 7).to_i
    time = Time.parse(timestamp)
    case true
      when Time.now.strftime('%D') == time.strftime('%D') then 'warning'
      when Time.now.to_i > time.to_i then 'error'
      when (time.to_i - Time.now.to_i) < (due_def * 86400) then 'success'
      else 'regular'
    end
  end

  def linkify(item)
    return if item.nil?
    item.gsub('.', '--')
  end

  def auto_link(text)
    Rinku.auto_link(text, :all, 'target="_blank"')
  end
end
