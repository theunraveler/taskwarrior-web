#!/usr/bin/env ruby

require 'sinatra'
require 'erb'
require 'time'
require 'rinku'
require 'digest'
require 'sinatra/simple-navigation'
require 'rack-flash'

class TaskwarriorWeb::App < Sinatra::Base
  autoload :Helpers, 'taskwarrior-web/helpers'

  @@root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
  set :root,  @@root    
  set :app_file, __FILE__
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :views, File.dirname(__FILE__) + '/views'
  set :method_override, true
  enable :sessions
  use Rack::Flash

  # Helpers
  helpers Helpers
  register Sinatra::SimpleNavigation
  
  # Authentication
  def protected!
    response['WWW-Authenticate'] = %(Basic realm="Taskworrior Web") and throw(:halt, [401, "Not authorized\n"]) and return unless authorized?
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    values = [TaskwarriorWeb::Config.property('task-web.user'), TaskwarriorWeb::Config.property('task-web.passwd')]
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == values
  end

  # Before filter
  before do
    @current_page = request.path_info
    protected! if TaskwarriorWeb::Config.property('task-web.user')
  end

  # Redirects
  get '/' do
    redirect '/tasks/pending'
  end
  get '/tasks/?' do
    redirect '/tasks/pending'
  end

  # Task routes
  get '/tasks/:status/?' do
    pass unless ['pending', 'waiting', 'completed', 'deleted'].include?(params[:status])
    @title = "Tasks"
    if params[:status] == 'pending' && filter = TaskwarriorWeb::Config.property('task-web.filter')
      @tasks = TaskwarriorWeb::Task.query(:description => filter)
    else
      @tasks = TaskwarriorWeb::Task.find_by_status(params[:status])
    end
    @tasks.sort_by! { |x| [x.priority.nil?.to_s, x.priority.to_s, x.due.nil?.to_s, x.due.to_s, x.project.to_s] }
    erb :listing
  end

  get '/tasks/new/?' do
    @title = 'New Task'
    @date_format = (TaskwarriorWeb::Config.dateformat || 'm/d/yy').gsub('Y', 'yy')
    erb :new_task
  end

  post '/tasks/?' do
    @task = TaskwarriorWeb::Task.new(params[:task])

    if @task.is_valid?
      flash[:success] = @task.save! || %Q{New task "#{@task.description.truncate(20)}" created}
      redirect '/tasks'
    end

    flash.now[:error] = @task._errors.join(', ')
    call! env.merge('REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/tasks/new')
  end

  get '/tasks/:uuid/?' do
    if tasks = TaskwarriorWeb::Task.find_by_uuid(params[:uuid])
      @task = tasks.first
      @title = %Q{Editing "#{@task.description.truncate(20)}"}
      erb :edit_task
    else
      halt 404
    end
  end

  patch '/tasks/:uuid/?' do
    if TaskwarriorWeb::Task.find_by_uuid(params[:uuid]).empty?
      halt 404
    end

    @task = TaskwarriorWeb::Task.new(params[:task])
    if @task.is_valid?
      flash[:success] = @task.save! || %Q{Task "#{@task.description.truncate(20)}" was successfully updated}
      redirect '/tasks'
    end

    flash.now[:error] = @task._errors.join(', ')
    call! env.merge('REQUEST_METHOD' => 'GET', 'PATH_INFO' => "/tasks/#{@task.uuid}")
  end

  get '/tasks/:uuid/delete/?' do
    if tasks = TaskwarriorWeb::Task.find_by_uuid(params[:uuid])
      @task = tasks.first
      @title = %Q{Are you sure you want to delete the task "#{@task.description.truncate(20)}"?}
      erb :delete_confirm
    else
      halt 404
    end
  end

  delete '/tasks/:uuid' do
    if tasks = TaskwarriorWeb::Task.find_by_uuid(params[:uuid])
      @task = tasks.first
      flash[:success] = @task.delete! || %Q{The task "#{@task.description.truncate(20)}" was successfully deleted}
      redirect '/tasks'
    else
      halt 404
    end
  end

  # Projects
  get '/projects' do
    redirect '/projects/overview'
  end

  get '/projects/overview/?' do
    @title = 'Projects'
    @tasks = TaskwarriorWeb::Task.query('status.not' => :deleted, 'project.not' => '')
      .sort_by! { |x| [x.priority.nil?.to_s, x.priority.to_s, x.due.nil?.to_s, x.due.to_s] }
      .group_by { |x| x.project.to_s }
      .reject { |project, tasks| tasks.select { |task| task.status == 'pending' }.empty? }
    erb :projects
  end

  get '/projects/:name/?' do
    @title = params[:name].gsub('--', '.') 
    @tasks = TaskwarriorWeb::Task.query('status.not' => 'deleted', :project => @title)
      .sort_by! { |x| [x.priority.nil?.to_s, x.priority.to_s, x.due.nil?.to_s, x.due.to_s] }
    erb :project
  end

  # AJAX callbacks
  get '/ajax/projects/?' do
    TaskwarriorWeb::Command.new(:projects).run.split("\n").to_json
  end

  get '/ajax/count/?' do
    self.class.task_count
  end

  get '/ajax/badge-count/?' do
    if filter = TaskwarriorWeb::Config.property('task-web.filter.badge')
      total = TaskwarriorWeb::Task.query(:description => filter).count
    else
      total = self.class.task_count
    end
    total == 0 ? '' : total.to_s
  end

  post '/ajax/task-complete/:id/?' do
    # Bummer that we have to directly use Command here, but apparently tasks
    # cannot be filtered by UUID.
    TaskwarriorWeb::Command.new(:complete, params[:id]).run
  end

  # Error handling
  not_found do
    @title = 'Page Not Found'
    @referrer = request.referrer
    erb :'404'
  end

  def self.task_count
    if filter = TaskwarriorWeb::Config.property('task-web.filter')
      total = TaskwarriorWeb::Task.query(:description => filter).count
    else
      total = TaskwarriorWeb::Task.count(:status => :pending)
    end
    total.to_s
  end
end
