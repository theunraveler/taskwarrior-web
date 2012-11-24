require 'active_support/core_ext/date/calculations'

module TaskwarriorWeb::App::Helpers

  def format_date(timestamp)
    format = TaskwarriorWeb::Config.dateformat || '%-m/%-d/%Y'
    Time.parse(timestamp).strftime(format)
  end

  def colorize_date(timestamp)
    return if timestamp.nil?
    due_def = (TaskwarriorWeb::Config.due || 7).to_i
    date = Date.parse(timestamp)
    case true
      when Date.today == date then 'warning'                            # today
      when Date.today > date then 'error'                               # overdue
      when Date.today.advance(:days => due_def) >= date then 'success'  # within the "due" range
      else 'regular'                                                    # just a regular task
    end
  end

  def linkify(item)
    return if item.nil?
    item.gsub('.', '--')
  end

  def auto_link(text)
    Rinku.auto_link(text, :all, 'target="_blank"')
  end

  def flash_types
    [:success, :info, :warning, :error]
  end
end
