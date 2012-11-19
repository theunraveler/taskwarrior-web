module TaskwarriorWeb::App::Helpers

  def format_date(timestamp)
    format = TaskwarriorWeb::Config.dateformat || 'm/d/Y'
    subbed = format.gsub(/([a-zA-Z])/, '%\1')
    Time.parse(timestamp).strftime(subbed)
  end

  def colorize_date(timestamp)
    return if timestamp.nil?
    due_def = TaskwarriorWeb::Config.due.to_i || 5
    time = Time.parse(timestamp)
    case true
      when Time.now.strftime('%D') == time.strftime('%D') then 'success'
      when Time.now.to_i > time.to_i then 'error'
      when (time.to_i - Time.now.to_i) < (due_def * 86400) then 'info'
      else 'regular'
    end
  end

  def linkify(item)
    return if item.nil?
    item.gsub('.', '--')
  end

  def idify(item)
    return if item.nil?
    linkify(item).gsub(' ', '-').gsub("'", '').downcase
  end

  def auto_link(text)
    Rinku.auto_link(text, :all, 'target="_blank"')
  end

  def subnav(type)
    case type
      when 'tasks'
        { '/tasks/pending' => "Pending <span class=\"badge\">#{TaskwarriorWeb::Task.count(:status => :pending)}</span>",
          '/tasks/waiting' => "Waiting",
          '/tasks/completed' => "Completed",
          '/tasks/deleted' => 'Deleted'
        }
      when 'projects'
        {
          '/projects/overview' => 'Overview'
        }
      else
        { }
    end
  end

end
