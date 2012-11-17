require 'taskwarrior-web/config'
require 'versionomy'

module TaskwarriorWeb
  module Parser
    def self.parse(results)
      if TaskwarriorWeb::Config.version > Versionomy.parse('1.9.2')
        require 'taskwarrior-web/parser/json'
        TaskwarriorWeb::Parser::Json.parse(results)
      else
        require 'taskwarrior-web/parser/csv'
        TaskwarriorWeb::Parser::Csv.parse(results)
      end
    end
  end
end
