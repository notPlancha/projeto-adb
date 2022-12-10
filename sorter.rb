require 'csv'

inputRows = CSV.read('data\countryAlias.csv')
sorted = inputRows.sort_by { |row| row[0].downcase }

# Write the CSV to a file
CSV.open('data\countryAlias.csv', "w") do |csv|
  # Write the headers
  csv << ["country", "alias", "code"]

  # Write the rows
  sorted.each do |row|
    csv << row
  end
end