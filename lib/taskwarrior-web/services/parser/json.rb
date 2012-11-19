require 'json'

module TaskwarriorWeb::Parser::Json
  def self.parse(json)
    json.strip!
    json = '[' + json + ']'
    json == '[No matches.]' ? [] : ::JSON.parse(json)
  end
end
