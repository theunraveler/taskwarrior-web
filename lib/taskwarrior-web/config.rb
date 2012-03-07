require 'parseconfig'

module TaskwarriorWeb
  class Config

    def self.task_version
      unless @task_version
        version_line = `task version | grep '^task '`
        @task_version = version_line.split.at(1)
      end

      @task_version
    end

    def self.file
      @file ||= ParseConfig.new("#{Dir.home}/.taskrc")
    end

    def self.property(prop)
      self.file.get_value(prop)
    end

    def self.method_missing(method)
      self.file.get_value(method)
    end

  end
end
