module TaskwarriorWeb::Parser
  autoload :Json, 'taskwarrior-web/services/parser/json'
  autoload :Csv,  'taskwarrior-web/services/parser/csv'

  def self.parse(results)
    if TaskwarriorWeb::Config.version > '1.9.2'
      Json.parse(results)
    else
      Csv.parse(results)
    end
  end
end
