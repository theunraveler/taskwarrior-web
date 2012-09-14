require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web/helpers'

class TestHelpers
  include TaskwarriorWeb::App::Helpers
end

describe TaskwarriorWeb::App::Helpers do
  let(:helpers) { TestHelpers.new }

  describe '#format_date' do
    context 'with no format specified' do
      before do
        TaskwarriorWeb::Config.should_receive(:dateformat).any_number_of_times.and_return(nil)
      end

      it 'should format various dates and times to the default format' do
        helpers.format_date('2012-01-11 12:23:00').should == '01/11/2012'
        helpers.format_date('2012-01-11').should == '01/11/2012'
      end
    end

    context 'with a specified date format' do
      before do
        TaskwarriorWeb::Config.should_receive(:dateformat).any_number_of_times.and_return('d/m/Y')
      end

      it 'should format dates using the specified format' do
        helpers.format_date('2012-01-11 12:23:00').should == '11/01/2012'
        helpers.format_date('2012-01-11').should == '11/01/2012'
      end
    end
  end

  describe '#colorize_date' do
    context 'when no timestamp is given' do
      it 'should simply return' do
        TaskwarriorWeb::Config.should_not_receive(:due)
        helpers.colorize_date(nil)
      end
    end

    context 'with a due setting specified' do    
      before do
        TaskwarriorWeb::Config.should_receive(:due).any_number_of_times.and_return(3)
      end

      it 'should return "today" when a given date is today' do
        helpers.colorize_date(Time.now.to_s).should eq('success') 
      end

      it 'should return "overdue" when a date is before today' do
        helpers.colorize_date(Time.at(0).to_s).should eq('error')
      end
    end
  end

  describe '#auto_link' do
    it 'should just call Rinku.auto_link' do
      Rinku.should_receive(:auto_link).with('hello', :all, 'target="_blank"')
      helpers.auto_link('hello')
    end
  end
end

