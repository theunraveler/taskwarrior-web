#!/usr/bin/env ruby

require 'sinatra'
require 'erb'
require 'parseconfig'
require 'json'

module TaskwarriorWeb
  class App < Sinatra::Base

    # Before filter
    before do
      @current_page = request.path_info
    end

    # Helpers
    helpers do

      def format_date(timestamp)
        format = Taskwarrior::Config.file.get_value('dateformat') || 'm/d/Y'
        subbed = format.gsub(/([a-zA-Z])/, '%\1')
        Time.parse(timestamp).strftime(subbed)
      end

      def colorize_date(timestamp)
        return if timestamp.nil?
        due_def = Taskwarrior::Config.file.get_value('due').to_i || 5
        time = Time.parse(timestamp)
        case true
          when Time.now.to_date == time.to_date then 'today'
          when Time.now.to_i > time.to_i then 'overdue'
          when (time.to_i - Time.now.to_i) < (due_def * 86400) then 'due'
          else 'regular'
        end
      end

      def linkify(item, method)
        return if item.nil?
        case method.to_s
          when 'project'
            item.downcase.gsub('.', '--')
        end
      end

      def subnav(type)
        case type
          when 'tasks' then
            { '/tasks/pending' => "Pending (#{Taskwarrior::Task.count(:status => 'pending')})", 
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

    # Redirects
    get '/' do
      redirect '/tasks/pending'
    end
    get '/tasks/?' do
      redirect '/tasks/pending'
    end

    # Task routes
    get '/tasks/:status/?' do
      pass unless ['pending', 'completed', 'deleted'].include?(params[:status])
      @title = "#{params[:status].capitalize} Tasks"
      @subnav = subnav('tasks')
      @tasks = Taskwarrior::Task.find_by_status(params[:status]).sort_by! { |x| [x.due.nil?.to_s, x.due.to_s, x.project.to_s] }
      erb :listing
    end

    get '/tasks/new/?' do
      @title = 'New Task'
      @subnav = subnav('tasks')
      @date_format = Taskwarrior::Config.file.get_value('dateformat') || 'm/d/yy'
      @date_format.gsub!('Y', 'yy')
      erb :task_form
    end

    post '/tasks/new/?' do
      results = passes_validation(params[:task], :task)
      if results.empty?
        task = Taskwarrior::Task.new(params[:task])
        task.save!.to_s
        redirect '/tasks'
      else
        @task = params[:task]
        @messages = []
        results.each do |result|
          @messages << { :severity => 'error', :message => result }
        end
        redirect '/tasks/new'
      end
    end

    post '/tasks/:id/complete' do
      Taskwarrior::Task.complete!(params[:id])
      redirect '/tasks/pending'
    end

    # Projects
    get '/projects' do
      redirect '/projects/overview'
    end

    get '/projects/overview/?' do
      @title = 'Projects'
      @subnav = subnav('projects')
      @tasks = Taskwarrior::Task.query('status.not' => 'deleted', 'project.not' => '').group_by { |x| x.project.to_s }
      erb :projects
    end

    get '/projects/:name/?' do
      @subnav = subnav('projects')
      subbed = params[:name].gsub('--', '.') 
      @tasks = Taskwarrior::Task.query('status.not' => 'deleted', 'project' => subbed).sort_by! { |x| [x.due.nil?.to_s, x.due.to_s] }
      regex = Regexp.new("^#{subbed}$", Regexp::IGNORECASE)
      @title = @tasks.select { |t| t.project.match(regex) }.first.project
      erb :project
    end

    # Reporting
    get '/reports' do
    end

    # AJAX callbacks
    get '/ajax/projects/?' do
      projects = Taskwarrior::Task.query('status.not' => 'deleted').collect { |t| t.project }
      projects.compact!.uniq!.to_json
    end

    get '/ajax/tags/?' do
      tags = []
      Taskwarrior::Task.query('status.not' => 'deleted').each do |task|
        tags = tags + task.tags
      end
      tags.compact!.uniq!.to_json
    end

    # Error handling
    not_found do
      @title = 'Page Not Found'
      @referrer = request.referrer
      erb :'404'
    end

    def passes_validation(item, method)
      results = [] 
      case method.to_s
        when 'task'
          if item['description'].empty?
            results << 'You must provide a description'
          end
      end
      results
    end

  end
end
