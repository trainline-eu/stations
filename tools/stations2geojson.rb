#!/usr/bin/env ruby

require 'csv'
require 'json'

# A script to create a mappable edition of the stations.csv database.
# To create GeoJSON from `stations.csv` download the stations.csv file and pipe through
# this script:
#	curl https://raw.githubusercontent.com/capitainetrain/stations/master/stations.csv > stations.csv
#	stations2geojson.rb < stations.csv > stations.geojson
# This script is designed to be short and simple. No error or conformance checking is
# performed.

features = []

CSV.new(STDIN, :headers => true, :col_sep => ";", :encoding => "UTF-8").each do |station|
  if station["longitude"] && station["latitude"]
    features << {
      :type => "Feature",
      :geometry => {
        :type => "Point",
        :coordinates => [station["longitude"].to_f, station["latitude"].to_f]
      },
      :properties => {
        :name => station["name"]
      }
    }
  end
end

puts({
  :type => "FeatureCollection",
  :features => features
}.to_json)

# LICENSE
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Graham Miln, http://miln.eu and https://www.capitainetrain.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
