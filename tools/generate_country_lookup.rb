require 'csv'
require 'uk_postcode/tree'

COUNTRIES = {
  'E92000001' => :england,
  'N92000002' => :northern_ireland,
  'S92000003' => :scotland,
  'W92000004' => :wales,
  'L93000001' => :channel_islands,
  'M83000003' => :isle_of_man
}

tree = UKPostcode::Tree.new.tap { | t|
  CSV.new(ARGF, headers: [:postcode, :country]).each do |row|
    path = row[:postcode].scan(/\S/)
    t.insert path, COUNTRIES.fetch(row[:country])
  end
}.compress

puts <<END
class UKPostcode
  class Country
    LOOKUP = {
END
COUNTRIES.values.each do |country|
  regexp = tree.filter(country).regexp
  puts "      #{country}: #{regexp.inspect},"
end
puts <<END
    }
  end
end
END
