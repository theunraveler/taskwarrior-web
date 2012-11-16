require 'parseconfig'
require 'versionomy'

module TaskwarriorWeb
  class Config

    def self.version
      @version ||= Versionomy.parse(`task _version`.strip)
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
