require "csv"
require "net/http"

CSV_PARAMS = {
  :col_sep => ";",
  :headers => true,
  :header_converters => :symbol
}

has_sncf_self_service_machine = Hash.new

puts "Downloading latest version of bls.csv"
File.write("bls.csv", Net::HTTP.get(URI.parse("https://raw.githubusercontent.com/swcc/bls/master/bls.csv")))

CSV.foreach("bls.csv", { :col_sep => ",", :headers => true }) do |row|
  if row["ct_id"]
    has_sncf_self_service_machine[row["ct_id"]] = row["hasMachine"]
  end
end

puts "Updating stations.csv"
CSV.open('new_stations.csv', 'w', CSV_PARAMS) do |csv|
  headers = CSV.foreach("stations.csv", {:col_sep => ";"}).first
  csv << headers

  CSV.foreach("stations.csv", CSV_PARAMS) do |row|
    if has_sncf_self_service_machine[row[:id]]
      if has_sncf_self_service_machine[row[:id]] == "true"
        row[:sncf_self_service_machine] = "t"
      else
        row[:sncf_self_service_machine] = "f"
      end
    end

    csv << row
  end
end

File.delete("bls.csv")
File.delete("stations.csv")
File.rename("new_stations.csv", "stations.csv")

puts "stations.csv has been updated! Make sure all tests pass."
