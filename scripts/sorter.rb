require 'csv'

inputRows = CSV.read('data\countryAlias.csv')
sorted = inputRows.sort_by { |row| row[1].downcase }

# Write the CSV to a file
CSV.open('data\countryAlias.csv', "w") do |csv|
  # Write the headers
  csv << ["alias", "country", "code"]

  # Write the rows
  sorted.each do |row|
    csv << row
  end
end