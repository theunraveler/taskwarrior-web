require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/runner'

describe TaskwarriorWeb::Runner do

  describe '.run' do
    it 'should execute the given command' do
      TaskwarriorWeb::Runner.should_receive(:`).with('task add')
      TaskwarriorWeb::Runner.run('add')
    end

    it 'should return the stdout' do
      TaskwarriorWeb::Runner.should_receive(:`).and_return('{}')
      TaskwarriorWeb::Runner.run('test').should eq('{}')
    end
  end

  describe '.parse_args' do
    it 'should collapse args into a string' do
      parsed = TaskwarriorWeb::Runner.parse_args(:test => 'Hello', :none => 'Yep')
      parsed.should eq(' test:Hello none:Yep')
    end

    it 'should allow symbols are argument values' do
      parsed = TaskwarriorWeb::Runner.parse_args(:test => :Hello, :none => :Yep)
      parsed.should eq(' test:Hello none:Yep')
    end
  end

end
