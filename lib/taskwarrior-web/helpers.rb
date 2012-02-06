require 'taskwarrior-web/config'

module TaskwarriorWeb
  class App < Sinatra::Base
    module Helpers

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
          when Time.now.strftime('%D') == time.strftime('%D') then 'today'
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

      def auto_link(text)
        Rinku.auto_link(text, :all, 'target="_blank"')
      end

      def subnav(type)
        case type
          when 'tasks' then
            { '/tasks/pending' => "Pending (#{TaskwarriorWeb::Task.count(:status => :pending)})", 
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
  end
end
