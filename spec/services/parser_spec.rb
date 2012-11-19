require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/services/parser'

describe TaskwarriorWeb::Parser do
  describe '.parse' do
    context 'when the task version is <= 1.9.2' do
      it 'should parse output as CSV' do
        TaskwarriorWeb::Config.should_receive(:version).and_return('1.0.0')
        TaskwarriorWeb::Parser::Csv.should_receive(:parse).once.with('hello')
        TaskwarriorWeb::Parser.parse('hello')
      end
    end
  end
end
