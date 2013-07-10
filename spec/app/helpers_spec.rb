require File.dirname(__FILE__) + '/../spec_helper'
require 'taskwarrior-web'
require 'active_support/core_ext/date/calculations'

class TestHelpers
  include TaskwarriorWeb::App::Helpers
end

describe TaskwarriorWeb::App::Helpers do
  let(:helpers) { TestHelpers.new }

  describe '#format_date' do
    context 'with no format specified' do
      it 'should format various dates and times to the default format' do
        allow(TaskwarriorWeb::Config).to receive(:dateformat).and_return(nil)
        helpers.format_date('2012-01-11 12:23:00').should eq('1/11/2012')
        helpers.format_date('2012-01-11').should eq('1/11/2012')
        helpers.format_date('20121231T230000Z').should eq(Time.parse('20121231T230000Z').localtime.strftime('%-m/%-d/%Y'))
        helpers.format_date('20121231T230000Z').should eq(Time.parse('20121231T230000Z').strftime('%-m/%-d/%Y'))
      end
    end

    context 'with a specified date format' do
      it 'should format dates using the specified format' do
        allow(TaskwarriorWeb::Config).to receive(:dateformat).and_return('%d/%-m/%Y')
        helpers.format_date('2012-12-11 12:23:00').should eq('11/12/2012')
        helpers.format_date('2012-12-11').should eq('11/12/2012')
      end

      it 'should convert Taskwarrior formats to Ruby formats correctly' do
        allow(TaskwarriorWeb::Config).to receive(:store).and_return({ 'dateformat' => 'd/m/Y' })
        helpers.format_date('2012-01-11 12:23:00').should eq('11/1/2012')
        helpers.format_date('2012-12-02 12:23:00').should eq('2/12/2012')
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
        allow(TaskwarriorWeb::Config).to receive(:due).and_return(3)
      end

      it 'should return "warning" when a given date is today' do
        helpers.colorize_date(Time.now.to_s).should eq('warning')
      end

      it 'should return "error" when a date is before today' do
        helpers.colorize_date(Time.at(0).to_s).should eq('error')
      end

      it 'should return "success" when a date is within the specified range' do
        allow(TaskwarriorWeb::Config).to receive(:due).and_return(5)
        helpers.colorize_date(Date.tomorrow.to_s).should eq('success')
      end
    end

    context 'with no due setting specified' do
      before do
        allow(TaskwarriorWeb::Config).to receive(:due).and_return(nil)
      end

      it 'should use the default setting of 7 days' do
        helpers.colorize_date(Date.tomorrow.to_s).should eq('success')
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

