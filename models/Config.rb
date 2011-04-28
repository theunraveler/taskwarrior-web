module Taskwarrior
  module Config

    extend self

    def file
      @file ||= ParseConfig.new("#{Dir.home}/.taskrc")
    end

  end
end
