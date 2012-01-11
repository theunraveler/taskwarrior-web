require 'parseconfig'

module TaskwarriorWeb
  class Config

    def self.file
      @file ||= ParseConfig.new("#{Dir.home}/.taskrc")
    end

  end
end
