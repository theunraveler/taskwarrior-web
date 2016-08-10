require 'active_support/core_ext/date/calculations'

module TaskwarriorWeb::App::Helpers
  def format_date(timestamp)
    format = TaskwarriorWeb::Config.dateformat || '%-m/%-d/%Y'
    Time.parse(timestamp).localtime.strftime(format)
  end

  def format_tags(tags)
    tags.join(', ')
  end

  def colorize_date(timestamp)
    return if timestamp.nil?
    due_def = (TaskwarriorWeb::Config.due || 7).to_i
    date = Date.parse(timestamp)
    case
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
      total = TaskwarriorWeb::Task.query(filter).count
    else
      total = TaskwarriorWeb::Task.count(:status => :pending)
    end
    total.to_s
  end

  def badge_count
    if filter = TaskwarriorWeb::Config.property('task-web.filter.badge')
      total = TaskwarriorWeb::Task.query(filter).count
    else
      total = task_count
    end
    total.to_i == 0 ? '' : total.to_s
  end

  def progress_bar(tasks)
    return 0 if tasks.empty?
    doneness = (tasks.select { |t| t.status == 'completed' }.count.to_f / tasks.count.to_f) * 100
    string = %(<div class="progress progress-striped">)
    string << %(<div class="bar" style="width: #{doneness.to_i}%;"></div>&nbsp;#{doneness.to_i}%)
    string << %(</div>)
    string
  end

  def crud_links(task)
    string = %(<span class="crud-links">)
    string << %(<a class="annotation-add" href="/tasks/#{task.uuid}/annotations/new"><i class="icon-comment"></i></a>)
    string << %(&nbsp;|&nbsp;)
    string << %(<a href="/tasks/#{task.uuid}?destination=#{ERB::Util.u(request.path_info)}"><i class="icon-pencil"></i></a>)
    string << %(&nbsp;|&nbsp;)
    string << %(<a href="/tasks/#{task.uuid}?destination=#{ERB::Util.u(request.path_info)}" data-method="DELETE" data-confirm="Are you sure you want to delete this task?"><i class="icon-trash"></i></a>)
    string << %(</span>)
    string
  end

  # Authentication
  def protected!
    response['WWW-Authenticate'] = %(Basic realm="Taskwarrior Web") and throw(:halt, [401, "Not authorized\n"]) and return unless authorized?
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    values = [TaskwarriorWeb::Config.property('task-web.user'), TaskwarriorWeb::Config.property('task-web.passwd')]
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == values
  end

  ##
  # Syncronise the local task database with the server
  def sync
    TaskwarriorWeb::Command.new(:sync, nil, nil).run
  end
end
