require "csv"
require "luhnacy"
require "minitest/autorun"
require "minitest/focus"
require "set"
require "stringex"
require "tzinfo"
require_relative "lib/constants"

STATIONS = CSV.read("stations.csv", **Constants::CSV_PARAMETERS)
STATIONS_BY_ID = STATIONS.each_with_object({}) do |station, hash|
  hash[station["id"]] = station
end

ALIASES = {}
CHILDREN = {}
CHILDREN_ENABLED_COUNT = Hash.new(0)
SLUG_COUNT = {}
STATIONS.each { |row| ALIASES[row["id"]] = [] }
STATIONS.each { |row| CHILDREN[row["id"]] = [] }
STATIONS.each { |row| SLUG_COUNT["#{row["slug"]}_#{row["country"]}"] = 0 }
SUGGESTABLE_STATIONS = STATIONS.select { |row| row['is_suggestable'] == 't' }

MALFORMED_ALIASES = []
MALFORMED_PARENTS = []

def has_enabled_carrier(row)
  Constants::CARRIERS.any? { |carrier| row["#{carrier}_is_enabled"] == "t" }
end

def has_carrier_id(row)
  Constants::CARRIERS.any? { |carrier| !row["#{carrier}_id"].nil? }
end

def has_rail_id(row)
  Constants::RAIL_IDS.keys.any? { |rail_id| !row[rail_id].nil? }
end

STATIONS.each do |row|
  if row["same_as"]
    if ALIASES[row["same_as"]].nil?
      MALFORMED_ALIASES << row
    end
    (ALIASES[row["same_as"]] || []) << row
  end

  if row["parent_station_id"]
    if CHILDREN[row["parent_station_id"]].nil?
      MALFORMED_PARENTS << row
    end
    (CHILDREN[row["parent_station_id"]] || []) << row
    if has_enabled_carrier(row) == "t"
      CHILDREN_ENABLED_COUNT[row["parent_station_id"]] += 1
    end
  end

  SLUG_COUNT["#{row["slug"]}_#{row["country"]}"] += 1
end

def slugify(name)
  name.gsub(/[\/\.]/,"-").to_ascii.to_url
end

#TAP TSI: ANNEX B.9
#STANDARD NUMERICAL CODING OF LOCATIONS
def uic8_valid?(uic8)
  Luhnacy.valid?("#{uic8[2..]}")
end

class StationsTest < Minitest::Test

  def test_is_station_useful
    useless_stations = []
    SUGGESTABLE_STATIONS.each do |row|
      if CHILDREN[row["id"]].empty? && !row["parent_station_id"]
        if !Constants::STATIONS_ENABLED_ELSEWHERE.include?(row["id"])
          useless_stations << row unless has_rail_id(row)
        end
      end
    end
    assert_equal 0, useless_stations.length, "Stations #{useless_stations.map {|row| row['id'].to_i }  } are useless and should be not suggestable"
  end

  def test_valid_timezone
    Constants::COUNTRIES.values.each do |timezone|
      assert TZInfo::Timezone.get(timezone)
    end
  end

  def test_number_columns
    nb_columns = 42 + (Constants::CARRIERS.size * 2)

    STATIONS.each { |row| assert_equal nb_columns, row.size, "Station #{row["name"]} (#{row["id"]}) has a wrong number of columns: #{row["size"]}" }
  end

  def test_station_name
    # If your test is failing due to an apostrophe ('), it needs to be this character: ’
    disallowed_characters = /(\"|\'|\`|\S\(|\)\S|\,|:|;|\?|\!|_| {2}| $)/
    disallowed_combinations = Constants::ALLOWED_COMBINATIONS_WITH_DOT.join("|")

    STATIONS.each do |row|
      assert !row["name"].nil?, "Station #{row["name"]} (#{row["id"]}) does not have a name"

      refute_match(disallowed_characters, row["name"], "Station #{row["name"]} (#{row["id"]}) has disallowed characters in its name")

      if !(Constants::ALLOWED_STATIONS_WITH_DOT.include?(row["id"]) || row["name"] =~ /(#{disallowed_combinations})/)
        refute_match(/\./, row["name"], "Station #{row["name"]} (#{row["id"]}) shouldn't have a dot in its name")
      end
    end
  end

  def test_rail_ids
    STATIONS.each do |row|
      Constants::RAIL_IDS.each do |rail_id, expression|
        if row[rail_id]
          assert_match(/^#{expression}$/, row[rail_id], "Station #{row["name"]} (#{row["id"]}) has not a correct #{rail_id}")
        end
      end
    end
  end

  def test_enabled_carrier_id
    STATIONS.each do |row|
      Constants::CARRIERS.each do |carrier|
        enabled_column = "#{carrier}_is_enabled"
        id_column      = "#{carrier}_id"
        if row[enabled_column] == "t"
          assert !row[id_column].nil?, "Station #{row["name"]} (#{row["id"]}) is enabled for #{carrier} but has no carrier id"
        end
      end
    end
  end

  def test_unique_ids
    id_columns = ["id"] + Constants::RAIL_IDS.keys
    id_columns.each do |id_column|
      counts = {}
      STATIONS.each do |row|
        if row[id_column]
          counts[row[id_column]] ||= 0
          counts[row[id_column]] += 1
        end
      end

      bad_counts = counts.select { |_, count| count != 1 }
      assert_equal 0, bad_counts.length, "#{id_column} duplicated: #{bad_counts.map(&:first).join(', ')}"
    end
  end

  def test_boolean_columns
    STATIONS.each do |row|
      Constants::BOOLEAN_COLUMNS.each do |column|
        assert ["t", "f"].include?(row[column]), "Station #{row["name"]} (#{row["id"]}] has an invalid value for #{column}"
      end
    end
  end

  def decimal_places(decimal)
    decimal =~ /\A-?\d{1,3}(\.(\d+))?\z/

    ($2 || "").length
  end

  def test_coordinates
    STATIONS.each do |row|
      lon = row["longitude"]
      lat = row["latitude"]

      if lon
        assert !lat.nil?, "Station #{row["name"]} (#{row["id"]}) has longitude but no latitude"
      end
      if lat
        assert !lon.nil?, "Station #{row["name"]} (#{row["id"]}) has latitude but no longitude"
      end

      if row["is_suggestable"] == "t"
        assert !lon.nil? && !lat.nil?, "Station #{row["name"]} (#{row["id"]}) is suggestable but has no coordinates"
      end

      if lon && lat
        # Test coordinates have a correct format (with a dot and not a comma)
        refute lat.include?(','), "Station #{row["name"]} (#{row["id"]}) latitude has a bad format"
        refute lon.include?(','), "Station #{row["name"]} (#{row["id"]}) longitude has a bad format"

        #assert decimal_places(lat) >= 2, "Station #{row["name"]} (#{row["id"]}) latitude is too imprecise"
        assert decimal_places(lat) <= 6, "Station #{row["name"]} (#{row["id"]}) latitude is too precise"
        #assert decimal_places(lon) >= 2, "Station #{row["name"]} (#{row["id"]}) longitude is too imprecise"
        assert decimal_places(lon) <= 6, "Station #{row["name"]} (#{row["id"]}) longitude is too precise"

        lon = lon.to_f
        lat = lat.to_f

        # Very rough bounding box of Europe
        # Mostly tests if lon and lat are not switched
        assert_operator lon, :>, -17, "Station #{row["name"]} (#{row["id"]}) has coordinates outside the bounding box"
        assert_operator lon, :<, 45,  "Station #{row["name"]} (#{row["id"]}) has coordinates outside the bounding box"
        assert_operator lat, :>, 30,  "Station #{row["name"]} (#{row["id"]}) has coordinates outside the bounding box"
        assert_operator lat, :<, 69,  "Station #{row["name"]} (#{row["id"]}) has coordinates outside the bounding box"
      end
    end
  end

  def test_sorted_by_id
    ids = STATIONS.map { |row| row["id"].to_i }

    assert ids == ids.sort, "Data is not sorted by the id column"
  end

  def test_country
    country_codes = Constants::COUNTRIES.keys
    STATIONS.each do |row|
      assert country_codes.include?(row["country"]), "Station #{row["name"]} (#{row["id"]}) has an unknown country"
    end
  end

  def test_timezone
    STATIONS.each do |row|
      timezone = Constants::COUNTRIES[row["country"]]
      assert_equal timezone, row["time_zone"], "Station #{row["name"]} (#{row["id"]}) has an invalid timezone"
    end
  end

  def test_unique_suggestable_name
    names = Set.new
    local_names = Set.new

    SUGGESTABLE_STATIONS.each do |row|
      name = row["name"]
      if row["country_hint"] == "f"
        refute names.include?(row["name"]), "Station #{name} (#{row["id"]}) has a name already used"
        names << row["name"]
      end
      refute local_names.include?("#{row['name']} (#{row['country']})"), "Station #{name} (#{row["id"]}) has a name already used in this country"
      local_names << "#{row['name']} (#{row['country']})"
    end
  end

  def test_child_localized_info
    STATIONS.each do |row|
      parent = STATIONS_BY_ID[row["parent_station_id"]]
      if !parent.nil? &&
        row["is_suggestable"] == "t" &&
        parent["is_suggestable"] == "t"
        Constants::LOCALES.each do |locale|
          if !parent["info:#{locale}"].nil?
            assert !row["info:#{locale}"].nil?, "Station #{row["name"]} (#{row["id"]}) has no \“#{locale}\” info while its parent #{parent["name"]} (#{parent["id"]}) has"
          end
        end
      end
    end
  end

  def test_localized_info_different_than_name
    SUGGESTABLE_STATIONS.each do |row|
      Constants::LOCALES.each do |locale|
        if !row["info:#{locale}"].nil?
          if ["ru", "ko", "zh", "ja"].include?(locale)
            refute_match(/[a-zA-Z]/, row["info:#{locale}"], "Station #{row["name"]} (#{row["id"]}) has not a valid “#{locale}” info")
          else
            locale_slug = slugify(row["info:#{locale}"])
            name_slug = slugify(row["name"])
            refute_match(/(^|-)#{name_slug}(-|$)/, locale_slug, "Station #{row["name"]} (#{row["id"]}) should have a different name and “#{locale}” info")
            refute_match(/(^|-)#{locale_slug}(-|$)/, name_slug, "Station #{row["name"]} (#{row["id"]}) should have a different name and “#{locale}” info")
          end
        end
      end
    end
  end

  def test_suggestable_has_carrier
    # Cercanias stations do not need a carrier
    cercanias_stations = ["68192".."68228", "74454".."74630"].flat_map(&:to_a) # Stations in Cercanias networks
    cercanias_stations += ["35841", "6485", "6501", "74651"] # Misc Cercanias stations
    useless_stations = []
    SUGGESTABLE_STATIONS.each do |row|
      unless has_enabled_carrier(row) ||
        CHILDREN[row["id"]].any? { |r| has_enabled_carrier(r) } ||
        (row["parent_station_id"] && has_enabled_carrier(STATIONS_BY_ID[row["parent_station_id"]])) ||
        cercanias_stations.include?(row["id"])
        useless_stations << row
      end
    end
    assert_equal 0, useless_stations.length, "Stations #{useless_stations.map {|row| row['id'].to_i }  } are suggestable but has no enabled system"
  end

  def test_malformed_parent
    assert_empty(MALFORMED_PARENTS, "Stations have a bogus parent_station_id: #{MALFORMED_PARENTS.map { |s| "#{s["name"]} (#{s["id"]}) → #{s["parent_station_id"]}" }.join(", ")}")
  end

  def test_parent_station
    SUGGESTABLE_STATIONS.each do |row|
      parent_id = row["parent_station_id"]
      if parent_id
        parent = STATIONS_BY_ID[parent_id]
        assert !parent.nil?, "Station #{row["name"]} (#{row["id"]}) references a nonexistent parent station (#{parent_id})"
        refute_equal parent_id, row["id"], "Station #{row["name"]} (#{row["id"]}) references itself as a parent station"
      end
    end
  end

  def test_parent_max_depth
    STATIONS.each do |row|
      current = row
      track = []
      depth = 0

      while !current["parent_station_id"].nil? do
        track << current["id"]
        depth += 1
        assert depth < Constants::PARENTHOOD_TREE_MAX_DEPTH, "Parenthood tree too deep: #{track.join(' >> ')}"
        current = STATIONS_BY_ID[current["parent_station_id"]]
      end
    end
  end

  def test_parent_have_multiple_children
    CHILDREN_ENABLED_COUNT.each do |parent_id, count|
      parent_station = STATIONS_BY_ID[parent_id]
      if parent_station["is_suggestable"] == "t"
        assert count >= 2, "Parent station #{parent_station["name"]} (#{parent_station["id"]}) is suggestable and has only #{count} child"
      end
    end
  end

  def test_parent_should_be_city
    CHILDREN.each do |parent_id, children_list|
      parent_station = STATIONS_BY_ID[parent_id]

      if children_list.size >= 1
        parent_station = STATIONS_BY_ID[parent_id]
        if !has_carrier_id(parent_station)
          refute_equal parent_station["is_city"], "f", "Parent station #{parent_station["name"]} (#{parent_station["id"]}) has no carrier id and should be flagged as city"
        end
      end

      if children_list.size >= 2 &&
        parent_station["parent_station_id"].nil? &&
        children_list.all? { |child| child["is_suggestable"] == "t" && child["slug"].start_with?(parent_station["slug"]) && child["slug"] != parent_station["slug"] && parent_station["is_airport"] == "f" }
          refute_equal parent_station["is_city"], "f", "Parent station #{parent_station["name"]} (#{parent_station["id"]}) should be a city"
      end
    end
  end

  def test_city_is_not_main_station
    STATIONS.each do |row|
      if row["is_city"] == "t"
        assert_equal "f", row["is_main_station"], "The city #{row["name"]} (#{row["id"]}) cannot be a main station at the same time"
      end
    end
  end

  def test_city_is_not_airport
    STATIONS.each do |row|
      if row["is_city"] == "t"
        assert_equal "f", row["is_airport"], "The city #{row["name"]} (#{row["id"]}) cannot be an airport at the same time"
      end
    end
  end

  def test_parent_has_main_station
    CHILDREN.each do |parent_id, children_list|
      parent_station = STATIONS_BY_ID[parent_id]
      if (children_list.size >= 2 && CHILDREN_ENABLED_COUNT[parent_id] > 1) &&
        parent_station["is_suggestable"] == "t" &&
        parent_station["is_main_station"] == "f" &&
        parent_station["parent_station_id"].nil?

          main_station_count = children_list.select { |child| child["is_main_station"] == "t" }.size
          assert_equal 1, main_station_count, "Parent station #{parent_station["name"]} (#{parent_station["id"]}) should have one and only one main station"
      end
    end
  end

  def test_main_station_must_be_parent_or_child
    STATIONS.each do |row|
      if row["is_main_station"] == "t"
        is_parent_or_child = CHILDREN[row["id"]].size > 0 || row["parent_station_id"]
        assert is_parent_or_child, "Station #{row["name"]} (#{row["id"]}) cannot be the main station as it is not a parent or child station"
      end
    end
  end

  def test_slugify
    assert_equal slugify("Figueras/Figueres Vilafant Esp."), "figueras-figueres-vilafant-esp"
  end

  def test_unique_slugs
    unique_set = Set.new

    SUGGESTABLE_STATIONS.each do |row|
      assert !unique_set.include?(row["slug"]), "Station #{row["name"]} (#{row["id"]}) has a slug already used: #{row["slug"]}"
      unique_set << row["slug"]
    end
  end

  def test_correct_slugs
    suffixes = {}
    STATIONS.each do |row|
      country = row["country"]
      if suffixes[country].nil?
        country_suffixes = Constants::DUPLICATE_STATION_SUFFIXES
        country_suffixes += Constants::HOMONYM_SUFFIXES[country] || []
        country_suffixes << country.downcase
        suffixes[country] = country_suffixes.join("|")
      end
      assert_match(/^#{slugify(row["name"])}-?(#{suffixes[country]})?$/, row["slug"], "Station #{row["name"]} (#{row["id"]}) has an incorrect slug")
    end
  end

  def test_slugs_with_countries_have_country_hint
    STATIONS.each do |row|
      if row["slug"].end_with?("-#{row["country"]}")
        assert_equal "t", row["country_hint"], "Station #{row["name"]} (#{row["id"]}) has its country in it slug but country_hint is not set."
      end
    end
  end

  def test_uic_country
    STATIONS.each do |row|
      if !Constants::UIC_KNOWN_DISCREPANCIES.include?(row["id"]) &&
        !row["uic"].nil? &&
        !Constants::COUNTRIES_UIC_CODES[row["country"]].nil?

        assert Constants::COUNTRIES_UIC_CODES[row["country"]].include?(row["uic"][0..1]), "Station #{row["name"]} (#{row["id"]}) has a mismatch between its UIC country code (#{row["uic"][0..1]}) and its country (#{row["country"]}: #{Constants::COUNTRIES_UIC_CODES[row["country"]].join(", ")})"
      end
    end
  end

  def test_uic_unique
    uic_list = Set.new

    STATIONS.each do |row|
      if !row["uic"].nil? && row["same_as"].nil?
        assert !uic_list.include?(row["uic"]), "Station #{row["name"]} (#{row["id"]}) has its UIC code (#{row["uic"]}) already in use."

        uic_list << row["uic"]
      end
    end
  end

  def test_uic8_sncf
    STATIONS.each do |row|
      uic8_sncf = row["uic8_sncf"] || "#{row["uic"]}x"
      uic = row["uic"]
      if !uic.nil? && !uic8_sncf.nil?
        assert uic == uic8_sncf[0...-1], "Station #{row["name"]} (#{row["id"]}) has its uic and uic8_sncf that do not match."
        assert uic8_valid?(uic8_sncf), "Station #{row["name"]} (#{row["id"]}) has an incorrect uic8_sncf code. It should be \"#{uic[0..1]}#{Luhnacy.generate(6, :prefix => uic[2..7])}\"."
      end
    end
  end

  def test_malformed_same_as
    assert_empty(MALFORMED_ALIASES, "Stations have a bogus same_as: #{MALFORMED_ALIASES.map { |s| "#{s["name"]} (#{s["id"]}) → #{s["same_as"]}"}.join(", ")}")
  end

  def test_station_should_be_same_as
    STATIONS.each do |row|
      if row["is_suggestable"] == "f" &&
        CHILDREN[row["id"]].empty? &&
        row["parent_station_id"].nil? &&
        ALIASES[row["id"]].empty? &&
        row["same_as"].nil?

        assert_equal 1, SLUG_COUNT["#{row["slug"]}_#{row["country"]}"],
          "Station #{row["name"]} (#{row["id"]}) can be an alias of a station with the same name"
      end
    end
  end

  def test_same_as_is_valid
    STATIONS.each do |row|
      if row["same_as"]
        assert_equal "f", row["is_suggestable"], "Station #{row["name"]} (#{row["id"]}) cannot be an alias and suggestable"
        refute_equal row["same_as"], row["id"], "Station #{row["name"]} (#{row["id"]}) references itself as an alias station"

        actual_station = STATIONS_BY_ID[row["same_as"]]
        assert row["slug"].start_with?(actual_station["slug"]), "Station #{row["name"]} (#{row["id"]}) is an alias of a station with a different name"
        assert !actual_station.nil?, "Station #{row["name"]} (#{row["id"]}) is an alias of a station that does not exist"
      end
    end
  end

  def test_same_as_rail_ids
    STATIONS.each do |row|
      if row["same_as"]
        actual_station = STATIONS_BY_ID[row["same_as"]]
        Constants::RAIL_IDS.keys.each do |rail_id|
          if row[rail_id]
            assert !actual_station[rail_id].nil?, "Actual station #{actual_station["name"]} (#{actual_station["id"]}) has not a #{rail_id} while its alias #{row["id"]} has one"
          end
        end
      end
    end
  end

  def test_sncf_self_service_machine
    STATIONS.each do |row|
      if row["sncf_self_service_machine"] == "t"
        assert_equal "FR", row["country"], "Station #{row["name"]} (#{row["id"]}) has a SNCF self-service machine but is not located in France"
        assert !row["sncf_id"].nil?, "Station #{row["name"]} (#{row["id"]}) has a SNCF self-service machine but is without SNCF id"
      end
    end
  end

  def test_sncf_virtual_station
    Constants::VIRTUAL_STATIONS.each do |id|
      station = STATIONS_BY_ID[id]
      assert_equal "t", station["sncf_is_enabled"], "Virtual station #{station["name"]} (#{station["id"]}) should be enabled for SNCF"
    end
  end

  def test_airports_comments_and_children
    # Check that no airport station mention "airport" in the comments, and that all children are also airports
    SUGGESTABLE_STATIONS.select do |row|
      row['is_airport'] == 't'
    end.each do |row|
      refute has_localized_info?(row, Constants::AIRPORT_TRANSLATIONS),
        "One or more comments for #{row['name']} (#{row["id"]}) are mentionning an airport which is not needed as this stations is flagged as an airport"

      CHILDREN[row['id']].each do |child_row|
        assert child_row['is_airport'] == 't',
          "#{child_row['name']} (#{child_row['id']}) should be an airport, as a child of airport station #{row['name']} (#{row['id']})"
      end
    end
  end

  def test_country_hints_and_children
    # Do not activate this test for Wien children stations.
    # It has no sense to precise the country when user searches for Wien Speising. He knows what he is looking for.
    exceptions = [
      "26862", # Wien
    ]

    SUGGESTABLE_STATIONS.select do |row|
      row['country_hint'] == 't' && !exceptions.include?(row['id'])
    end.each do |row|
      CHILDREN[row['id']].each do |child_row|
        assert child_row['country_hint'] == 't',
          "#{child_row['name']} (#{child_row['id']}) should have country hint enabled, as a child of country hinted station #{row['name']} (#{row['id']})"
      end
    end
  end

  def test_main_station_hints
    # Check that no main station mentions "main station" in the comments
    SUGGESTABLE_STATIONS.select do |row|
      row['main_station_hint'] == 't'
    end.each do |row|
      refute has_localized_info?(row, Constants::MAIN_STATION_TRANSLATIONS),
        "One or more comments for #{row['name']} (#{row["id"]}) are mentionning a main station which is not needed as this stations is flagged with main_station_hint"
    end
  end

  def test_normalised_code
    gb_stations_without_normalised_codes = []
    STATIONS.each do |row|
      if row["country"] != 'GB'
        assert !row["normalised_code"].nil?, "Station #{row["name"]} (#{row["id"]}) does not have a normalised_code"
        expected_id = row["same_as"] || row["id"]
        assert_equal("urn:trainline:public:nloc:csv#{expected_id}", row["normalised_code"])
      else
        if row["normalised_code"].nil?
          gb_stations_without_normalised_codes << "Station #{row["name"]} (#{row["id"]})"
        else
          assert_equal(true, row["normalised_code"].start_with?("urn:trainline:public:nloc:at"), "GB station normalised codes should be in correct format")
        end
      end
    end
    assert_equal(26, gb_stations_without_normalised_codes.length, "There should be 26 GB stations without a normalised code")
  end

  # [TEMP] To be removed
  def test_ids_reserved
    STATIONS.each do |row|
      id = row["id"].to_i
      assert id < 32623 || id > 33295
    end
  end<

  # buses must only be mapped to cities or airports, not to specific stations
  def test_coach_city_airport
    invalid = []

    STATIONS.each do |row|
      if row['flixbus_is_enabled'] == 'f' && row['busbud_is_enabled'] == 'f' && row['distribusion_is_enabled'] == 'f'
        next
      end
      if row['is_airport'] == 'f' &&
        row['is_city'] == 'f' &&
        row['parent_station_id'] &&
        !Constants::BUS_PRECISE_STATION.include?(row['id'])
        invalid << row['id']
      end
    end
    assert_equal [], invalid
  end

  def test_distribusion_airport
    invalid = []

    STATIONS.each do |row|
      if row['distribusion_is_enabled'] == 't' &&
          row['is_airport'] == 't' &&
          row['distribusion_id'] !~ /^@FRPAR/ && # For Paris we allow to map terminals
          !Constants::BUS_PRECISE_STATION.include?(row['id'])
        if row['distribusion_id'].length >= 8
          invalid << row['id']
        end
      end
    end
    assert_equal [], invalid, "Stations need to map to a distribusion area and not to stations"
  end

  def test_is_airport_enabled_when_station_name_contains_airport
    invalid = []
    STATIONS.each do |row|
      if row['name'].downcase.include?("airport") && row['is_airport'] == 'f'
        invalid << row['id']
      end
    end
    assert_equal [], invalid, "Stations need to be airport"
  end

  def test_valid_iata_airport_codes
    iata_codes = []
    STATIONS.each do |row|
      if !row['iata_airport_code'].nil?
        message = "IATA code must be unique: '#{row['iata_airport_code']}' appears more than once"
        refute iata_codes.include?(row['iata_airport_code']), message
        iata_codes << row['iata_airport_code']

        assert row['iata_airport_code'] =~ /^[A-Z]{3}$/, "Invalid IATA code: '#{row['iata_airport_code']}'"
      end
    end
  end

  private

  def has_localized_info?(row, translations)
    translations.any? do |locale, translation|
      slugify(row["info:#{locale}"] || '') =~ /#{translation}/i
    end
  end

  def has_localized_mention?(value, translations)
    translations.any? do |locale, translation|
      slugify(value || '') =~ /#{translation}/i
    end
  end

end
