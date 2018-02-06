#!/usr/bin/env ruby

require 'csv'

cities = {}

CSV.open("stations.csv", :headers => true, :col_sep => ";", :encoding => "UTF-8").each do |station|
  if station["is_city"] == "t" or station["parent_station_id"] != ""
    if station["sncf_is_enabled"] == "t" || station["renfe_is_enabled"] == "t" || station["trenitalia_is_enabled"] == "t" || station["flixbus_is_enabled"] == "t" || station["busbud_is_enabled"] == "t" || station["distribusion_is_enabled"] == "t"

      if station["parent_station_id"]
        id = station["parent_station_id"]
      else
        id = station["id"]
      end
      cities[id] ||= {
        :country => station["country"],
        :bus => false,
        :train => false
      }
      if station["sncf_is_enabled"] == "t" || station["renfe_is_enabled"] == "t" || station["trenitalia_is_enabled"] == "t"
        cities[id][:train] = true
      end
      if station["flixbus_is_enabled"] == "t" || station["busbud_is_enabled"] == "t" || station["distribusion_is_enabled"] == "t"
        cities[id][:bus] = true
      end
    end

  end
end

require 'pp';

res = {}

cities.values.each do |city|
  res[city[:country]] ||= {:total => 0, :train_only => 0, :bus_only => 0}

  res[city[:country]][:total] += 1

  if city[:train] && city[:bus] == false
    res[city[:country]][:train_only] += 1
  end
  if city[:bus] && city[:train] == false
    res[city[:country]][:bus_only] += 1
  end

end

pp res
