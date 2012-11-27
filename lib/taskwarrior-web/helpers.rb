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
    item.gsub('.', '--') unless item.nil? unless item.nil?
  end

  def unlinkify(item)
    item.gsub('--', '.') unless item.nil?
  end

  def auto_link(text)
    Rinku.auto_link(text, :all, 'target="_blank"')
  end

  def flash_types
    [:success, :info, :warning, :error]
  end

  def task_count
    if filter = TaskwarriorWeb::Config.property('task-web.filter')
      total = TaskwarriorWeb::Task.query(:description => filter).count
    else
      total = TaskwarriorWeb::Task.count(:status => :pending)
    end
    total.to_s
  end

  # Authentication
  def protected!
    response['WWW-Authenticate'] = %(Basic realm="Taskworrior Web") and throw(:halt, [401, "Not authorized\n"]) and return unless authorized?
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    values = [TaskwarriorWeb::Config.property('task-web.user'), TaskwarriorWeb::Config.property('task-web.passwd')]
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == values
  end
end
