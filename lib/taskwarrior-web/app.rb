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

  # Helpers
  helpers Helpers
  register Sinatra::SimpleNavigation
  use Rack::Flash
  
  # Before filter
  before do
    @current_page = request.path_info
    @can_edit = TaskwarriorWeb::Config.supports? :editing
    protected! if TaskwarriorWeb::Config.property('task-web.user')
  end

  # Redirects
  get('/') { redirect to('/tasks/pending') }
  get('/tasks/?') { redirect to('/tasks/pending') }
  get('/projects/?') { redirect to('/projects/overview') }

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
      message = @task.save!
      flash[:success] = message.blank? ? %Q{New task "#{@task.description.truncate(20)}" created} : message
      redirect to('/tasks')
    end

    flash.now[:error] = @task._errors.join(', ')
    forward '/tasks/new'
  end

  get '/tasks/:uuid/?' do
    not_found if !TaskwarriorWeb::Config.supports?(:editing)
    tasks = TaskwarriorWeb::Task.find_by_uuid(params[:uuid])
    not_found if tasks.empty?
    @task = tasks.first
    @title = %Q{Editing "#{@task.description.truncate(20)}"}
    erb :edit_task
  end

  patch '/tasks/:uuid/?' do
    not_found if !TaskwarriorWeb::Config.supports?(:editing)
    not_found if TaskwarriorWeb::Task.find_by_uuid(params[:uuid]).empty?

    @task = TaskwarriorWeb::Task.new(params[:task])
    if @task.is_valid?
      message = @task.save!
      flash[:success] = message.blank? ? %Q{Task "#{@task.description.truncate(20)}" was successfully updated} : message
      redirect to('/tasks')
    end

    flash.now[:error] = @task._errors.join(', ')
    forward "/tasks/#{@task.uuid}"
  end

  get '/tasks/:uuid/delete/?' do
    not_found if !TaskwarriorWeb::Config.supports?(:editing)
    tasks = TaskwarriorWeb::Task.find_by_uuid(params[:uuid])
    not_found if tasks.empty?
    @task = tasks.first
    @title = %Q{Are you sure you want to delete the task "#{@task.description.truncate(20)}"?}
    erb :delete_confirm
  end

  delete '/tasks/:uuid' do
    not_found if !TaskwarriorWeb::Config.supports?(:editing)
    tasks = TaskwarriorWeb::Task.find_by_uuid(params[:uuid])
    not_found if tasks.empty?
    @task = tasks.first
    message = @task.delete!
    flash[:success] = message.blank? ? %Q{Task "#{@task.description.truncate(20)}" was successfully deleted} : message
    redirect to('/tasks')
  end

  # Projects
  get '/projects/overview/?' do
    @title = 'Projects'
    @tasks = TaskwarriorWeb::Task.query('status.not' => :deleted, 'project.not' => '')
      .sort_by! { |x| [x.priority.nil?.to_s, x.priority.to_s, x.due.nil?.to_s, x.due.to_s] }
      .group_by { |x| x.project.to_s }
      .reject { |project, tasks| tasks.select { |task| task.status == 'pending' }.empty? }
    erb :projects
  end

  get '/projects/:name/?' do
    @title = unlinkify(params[:name])
    @tasks = TaskwarriorWeb::Task.query('status.not' => 'deleted', :project => @title)
      .sort_by! { |x| [x.priority.nil?.to_s, x.priority.to_s, x.due.nil?.to_s, x.due.to_s] }
    erb :project
  end

  # AJAX callbacks
  get('/ajax/projects/?') { TaskwarriorWeb::Command.new(:projects).run.split("\n").to_json }
  get('/ajax/count/?') { task_count }
  post('/ajax/task-complete/:id/?') { TaskwarriorWeb::Command.new(:complete, params[:id]).run }

  get '/ajax/badge/?' do
    if filter = TaskwarriorWeb::Config.property('task-web.filter.badge')
      total = TaskwarriorWeb::Task.query(:description => filter).count
    else
      total = task_count
    end
    total == 0 ? '' : total.to_s
  end

  # Error handling
  not_found do
    @title = 'Page Not Found'
    @referrer = request.referrer
    erb :'404'
  end
end
