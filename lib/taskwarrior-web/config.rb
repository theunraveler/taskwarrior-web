require 'parseconfig'

module TaskwarriorWeb
  class Config

    def self.task_version
      @task_version ||= `task _version`
    end

    def self.task_major_version
      self.task_version[0,1].to_i
    end

    def self.file
      @file ||= ParseConfig.new("#{Dir.home}/.taskrc")
    end

    def self.property(prop)
      self.file[prop]
    end

    def self.method_missing(method)
      self.file[method]
    end

  end
end
