require 'parseconfig'
require 'versionomy'

module TaskwarriorWeb::Config
  # A list of date formats, with Taskwarrior's on the left and the Ruby
  # equivalent on the right.
  DATEFORMATS = {
    'm' => '%-m',  # minimal-digit month, for example 1 or 12
    'd' => '%-d',   # minimal-digit day, for example 1 or 30
    'y' => '%y',   # two-digit year, for example 09
    'D' => '%d',   # two-digit day, for example 01 or 30
    'M' => '%m',   # two-digit month, for example 01 or 12
    'Y' => '%Y',   # four-digit year, for example 2009
    'a' => '%a',   # short name of weekday, for example Mon or Wed
    'A' => '%A',   # long name of weekday, for example Monday or Wednesday
    'b' => '%b',   # short name of month, for example Jan or Aug
    'B' => '%B',   # long name of month, for example January or August
    'V' => '%U',   # weeknumber, for example 03 or 37
    'H' => '%H',   # two-digit hour, for example 03 or 11
    'N' => '%M',   # two-digit minutes, for example 05 or 42
    'S' => '%S',   # two-digit seconds, for example 07 or 47
  }

  def self.version
    @version ||= Versionomy.parse(`#{TaskwarriorWeb::Runner::TASK_BIN} _version`.strip)
  end

  def self.file
    @file ||= ParseConfig.new("#{Dir.home}/.taskrc")
  end

  def self.property(prop)
    self.file[prop]
  end

  def self.dateformat
    self.file['dateformat'].gsub(/(\w)/, DATEFORMATS) unless self.file['dateformat'].nil?
  end

  def self.supports?(feature)
    case feature.to_sym
    when :editing
      self.version.major > 1
    else
      false
    end
  end

  def self.method_missing(method)
    self.file[method.to_s]
  end
end
