#!/usr/bin/env ruby

require 'csv'

# Parse options
if ARGV.length == 0 || (ARGV.length == 1 && ARGV[0] == '-h')
  puts 'Usage: ./tools/add_column.rb info:en-us --after=info:tr --sameas=info:en < stations.csv > stations.csv'
  puts '       ./tools/add_column.rb ntv_is_enabled --content=f < stations.csv > stations.csv'
  puts "       ./tools/add_column.rb carrier_id '--contentprog=row[3] if [\"8775561\"].include?(row[3])' < stations.csv > stations.csv"
  exit
end

CSV_PARAMS = { headers: true, col_sep: ';', encoding: 'UTF-8' }

csv = CSV.parse($stdin, **CSV_PARAMS)
headers = csv.headers
rows = csv.map { |row| row.fields }

column_name = ARGV[0]
column_before = nil
same_as = nil
column_content = nil
column_content_prog = nil

if ARGV.length > 1
  ARGV[1..-1].each do |arg|
    case arg
    when /^--after=/
      column_before = arg[8..-1]
    when /^--sameas=/
      same_as = arg[9..-1]
    when /^--content=/
      column_content = arg[10..-1]
    when /^--contentprog=/
      column_content_prog = arg[14..-1]
    end
  end
end

column_before ||= headers[-1]
column_insertion_index = headers.find_index(column_before) + 1
same_as_index = headers.find_index(same_as) if same_as

# Insertion

rows.each do |row|
  content = if same_as
              row[same_as_index]
            elsif column_content_prog
              eval(column_content_prog)
            else
              column_content
            end
  row.insert(column_insertion_index, content)
end

headers.insert(column_insertion_index, column_name)

# Output

output_csv = CSV.new($stdout, **CSV_PARAMS)
output_csv << headers
rows.each { |row| output_csv << row }
