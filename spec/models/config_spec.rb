require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/config'
require 'ostruct'

describe TaskwarriorWeb::Config do
  describe '.property' do
    it 'should call #get_value on the config file object' do
      file = OpenStruct.new
      TaskwarriorWeb::Config.should_receive(:file).and_return(file)
      file.should_receive(:get_value).with('testing')
      TaskwarriorWeb::Config.property('testing')
    end
  end
end
