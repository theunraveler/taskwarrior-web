module TaskwarriorWeb::Parser
  autoload :Json, 'taskwarrior-web/parser/json'
  autoload :Csv,  'taskwarrior-web/parser/csv'

  def self.parse(results)
    if TaskwarriorWeb::Config.version > '1.9.2'
      Json.parse(results)
    else
      Csv.parse(results)
    end
  end
end
