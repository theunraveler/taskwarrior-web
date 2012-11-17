require 'csv'

module TaskwarriorWeb::Parser::Csv
  def self.parse(csv)
    rows = []
    CSV.parse(csv, :headers => true, :quote_char => "'", :header_converters => :symbol, :converters => :all) do |row|
      rows << Hash[row.headers.zip(row.fields)]
    end
    rows
  end
end
