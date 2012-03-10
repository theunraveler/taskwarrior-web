require 'parseconfig'

module TaskwarriorWeb
  class Config

    def self.task_version
      @task_version ||= `task version | grep '^task '`.split.at(1)
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
