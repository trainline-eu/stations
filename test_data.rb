require "csv"
require "minitest/autorun"
require "set"
require "stringex"
require_relative "lib/constants"

STATIONS = CSV.read("stations.csv", Constants::CSV_PARAMETERS)
STATIONS_BY_ID = STATIONS.inject({}) { |hash, station| hash[station["id"]] = station; hash }

ALIASES = {}
CHILDREN = {}
CHILDREN_ENABLED_COUNT = Hash.new(0)
SLUG_COUNT = {}
STATIONS.each { |row| ALIASES[row["id"]] = []}
STATIONS.each { |row| CHILDREN[row["id"]] = [] }
STATIONS.each { |row| SLUG_COUNT["#{row["slug"]}_#{row["country"]}"] = 0 }

def has_enabled_carrier(row)
  row["atoc_is_enabled"]         == "t" ||
    row["benerail_is_enabled"]   == "t" ||
    row["busbud_is_enabled"]     == "t" ||
    row["db_is_enabled"]         == "t" ||
    row["hkx_is_enabled"]        == "t" ||
    row["idtgv_is_enabled"]      == "t" ||
    row["ntv_is_enabled"]        == "t" ||
    row["ouigo_is_enabled"]      == "t" ||
    row["renfe_is_enabled"]      == "t" ||
    row["sncf_is_enabled"]       == "t" ||
    row["trenitalia_is_enabled"] == "t"
end

def has_carrier_id(row)
  !row["atoc_id"].nil?          ||
    !row["benerail_id"].nil?    ||
    !row["busbud_id"].nil?      ||
    !row["db_id"].nil?          ||
    !row["hkx_id"].nil?         ||
    !row["idtgv_id"].nil?       ||
    !row["ntv_id"].nil?         ||
    !row["ouigo_id"].nil?       ||
    !row["renfe_id"].nil?       ||
    !row["sncf_id"].nil?        ||
    !row["trenitalia_id"].nil?
end

def has_any_id(row)
  has_carrier_id(row)       ||
  !row["uic"].nil?          ||
  !row["uic8_sncf"].nil?    ||
  !row["sncf_tvs_id"].nil?  ||
  !row["trenitalia_rtvt_id"].nil?
end

STATIONS.each do |row|
  if row["same_as"]
    ALIASES[row["same_as"]] << row
  end

  if row["parent_station_id"]
    CHILDREN[row["parent_station_id"]] << row
    if has_enabled_carrier(row) == "t"
      CHILDREN_ENABLED_COUNT[row["parent_station_id"]] += 1
    end
  end

  if row["slug"]
    SLUG_COUNT["#{row["slug"]}_#{row["country"]}"] += 1
  end
end

def slugify(name)
  name.gsub(/[\/\.]/,"-").to_ascii.to_url
end

def fold(name)
  name.to_ascii
      .downcase
      .gsub(/[^a-z]/, " ")
      .gsub(/\s+/, " ")
      .strip
end

class StationsTest < Minitest::Test

  def test_is_station_useful
    STATIONS.each do |row|
      if CHILDREN[row["id"]].empty?
        assert has_any_id(row), "Station #{row["name"]} (#{row["id"]}) is useless and should be removed"
      end
    end
  end

  def test_number_columns
    nb_columns = 57

    STATIONS.each { |row| assert_equal nb_columns, row.size, "Wrong number of columns #{row["size"]} for station #{row["id"]}" }
  end

  def test_enabled_and_id_columns
    Constants::CARRIER_IDS.each do |carrier, id_column_size|
      enabled_column = "#{carrier}_is_enabled"
      id_column      = "#{carrier}_id"
      unique_set     = Set.new

      STATIONS.each do |row|
        assert ["t", "f"].include?(row[enabled_column])

        id = row[id_column]
        if row[enabled_column] == "t"
          assert !id.nil?, "Missing #{id_column} for station #{row["id"]}"
        end

        if !id.nil?
          if id_column_size.is_a?(Array)
            assert id_column_size.include?(row[id_column].size), "Invalid #{id_column}: #{row[id_column]} for station #{row["id"]}"
          else
            assert_equal id_column_size, row[id_column].size, "Invalid #{id_column}: #{row[id_column]} for station #{row["id"]}"
          end

          assert !unique_set.include?(row[id_column]), "Duplicated #{id_column} #{row[id_column]} for station #{row["id"]}"
          unique_set << row[id_column]
        end
      end
    end
  end

  def validate_id_unicity(column_name)
    counts = {}
    STATIONS.each do |row|
      if row[column_name]
        counts[row[column_name]] = (counts[row[column_name]] || 0) + 1
      end
    end

    bad_counts = counts.select { |_, count| count != 1 }
    assert_equal 0, bad_counts.length, "#{column_name} duplicated: #{bad_counts.map(&:first).join(', ')}"
  end

  def test_id_unicity
    uniq_size = STATIONS.map { |row| row["id"] }.uniq.size

    assert_equal STATIONS.size, uniq_size
  end

  def test_uic_unicity
    validate_id_unicity("uic")
  end

  def test_sncf_tvs_id_unicity
    validate_id_unicity("sncf_tvs_id")
  end

  def test_trenitalia_rtvt_id_unicity
    validate_id_unicity("trenitalia_rtvt_id")
  end

  def test_coordinates
    STATIONS.each do |row|
      lon = row["longitude"]
      lat = row["latitude"]

      if lon
        assert !lat.nil?, "Longitude of station #{row["id"]} set, but not latitude"
      end
      if lat
        assert !lon.nil?, "Latitude of station #{row["id"]} set, but not longitude"
      end

      if row["is_suggestable"] == "t"
        assert !lon.nil? && !lat.nil?, "Station #{row["id"]} is suggestable but has no coordinates"
      end

      if lon && lat
        lon = lon.to_f
        lat = lat.to_f

        # Very rough bounding box of Europe
        # Mostly tests if lon and lat are not switched
        assert_operator lon, :>, -10, "Coordinates of station #{row["id"]} not within the bounding box"
        assert_operator lon, :<, 41, "Coordinates of station #{row["id"]} not within the bounding box"
        assert_operator lat, :>, 35, "Coordinates of station #{row["id"]} not within the bounding box"
        assert_operator lat, :<, 69, "Coordinates of station #{row["id"]} not within the bounding box"
      end
    end
  end

  def test_sorted_by_id
    ids = STATIONS.map { |row| row["id"].to_i }

    assert ids == ids.sort, "The data is not sorted by the id column"
  end

  def test_is_suggestable
    STATIONS.each do |row|
      assert ["t", "f"].include?(row["is_suggestable"]), "Invalid value for is_suggestable for station #{row["id"]}"
    end
  end

  def test_is_city
    STATIONS.each do |row|
      assert ["t", "f"].include?(row["is_city"]), "Invalid value for is_city for station #{row["id"]}"
    end
  end

  def test_is_main_station
    STATIONS.each do |row|
      assert ["t", "f"].include?(row["is_main_station"]), "Invalid value for is_main_station for station #{row["id"]}"
    end
  end

  def test_country
    country_codes = Constants::COUNTRIES.keys
    STATIONS.each do |row|
      assert country_codes.include?(row["country"]), "Invalid value for country for station #{row["id"]}"
    end
  end

  def test_timezone
    STATIONS.each do |row|
      timezone = Constants::COUNTRIES[row["country"]]
      assert_equal timezone, row["time_zone"], "Invalid timezone for station #{row["id"]}"
    end
  end

  def test_suggestable_has_name
    STATIONS.each do |row|
      if row["is_suggestable"] == "t"
        assert !row["name"].nil?, "Station #{row["id"]} is suggestable but has empty name"
      end
    end
  end

  def test_unique_suggestable_name
    names = Set.new

    STATIONS.each do |row|
      if row["is_suggestable"] == "t" && !Constants::HOMONYM_STATIONS.include?(row["id"])
        assert !names.include?(row["name"]), "Duplicate name '#{row["name"]}'"

        names << row["name"]
      end
    end
  end

  def test_homonym_suggestable
    Constants::HOMONYM_STATIONS.each do |homonym_id|
      homonym_station = STATIONS_BY_ID[homonym_id]
      assert_equal homonym_station["is_suggestable"], "t", "Homonym station #{homonym_station["name"]} (#{homonym_station["id"]}) is not suggestable"
    end
  end

  def test_homonym_information
    Constants::HOMONYM_STATIONS.each do |homonym_id|
      homonym_station = STATIONS_BY_ID[homonym_id]
      Constants::SUGGESTABLE_LOCALES.each do |locale|
        assert !homonym_station["info:#{locale}"].nil?, "Homonym station #{homonym_station["name"]} (#{homonym_station["id"]}) must have an info in “#{locale}”"
      end
    end
  end

  def test_homonym_exists
    stations = STATIONS.map do |station|
      {
        "id"           => station["id"],
        "folded_name"  => fold(station["name"] || ""),
        "suggestable?" => (station["is_suggestable"] == "t")
      }
    end

    Constants::HOMONYM_STATIONS.each do |homonym_id|
      homonym_station = STATIONS_BY_ID[homonym_id]
      folded_homonym_name = fold(homonym_station["name"] || "")
      has_homonym = stations.any? do |station|
        station["id"] != homonym_station["id"] &&
          station["folded_name"] == folded_homonym_name &&
          station["suggestable?"]
        end
        assert has_homonym,
          "Station #{homonym_station["name"]} (#{homonym_station["id"]}) does not have a suggestable homonym station"
    end
  end

  def test_info_different_than_name
    STATIONS.each do |row|
      if row["is_suggestable"] == "t"
        Constants::LOCALES.each do |locale|
          if !row["info:#{locale}"].nil?
            refute_equal row["name"], row["info:#{locale}"], "Name and “#{locale}” information should be different: '#{row["name"]}'"

            if !["ru", "ko", "zh", "ja"].include?(locale)
              refute_equal fold(row["name"]), fold(row["info:#{locale}"]), "Name and “#{locale}” information should be different: '#{row["name"]}'"
            end
          end
        end
      end
    end
  end

  def test_suggestable_has_carrier
    STATIONS.each do |row|
      if row["is_suggestable"] == "t"
        assert has_enabled_carrier(row) || CHILDREN[row["id"]].any? { |r| has_enabled_carrier(r) },
               "Station #{row["id"]} is suggestable but has no enabled system"
      end
    end
  end

  def test_parent_station
    STATIONS.each do |row|
      parent_id = row["parent_station_id"]
      if parent_id && row["is_suggestable"] == "t"
        parent = STATIONS_BY_ID[parent_id]
        assert !parent.nil?, "Station #{row["id"]} references a not existing parent station (#{parent_id})"
        assert !parent["name"].nil?, "The station #{parent_id} has no name (parent of station #{row["id"]})"
        refute_equal parent_id, row["id"], "Station #{row["id"]} references itself as a parent station"
        Constants::LOCALES.each do |locale|
          if !parent["info:#{locale}"].nil?
            assert !row["info:#{locale}"].nil?, "Station #{row["name"]} (#{row["id"]}) has no \“#{locale}\” info while its parent (#{parent["name"]}) has"
          end
        end
      end
    end
  end

  def test_parent_have_multiple_children
    CHILDREN_ENABLED_COUNT.each do |parent_id, count|
      parent_station = STATIONS_BY_ID[parent_id]
      if parent_station["is_suggestable"] == "t"
        assert count >= 2, "The parent station #{parent_station["name"]} (#{parent_station["id"]}) is suggestable and has only #{count} child"
      end
    end
  end

  def test_parent_should_be_city
    CHILDREN.each do |parent_id, children_list|
      parent_station = STATIONS_BY_ID[parent_id]

      if children_list.size >= 1
        parent_station = STATIONS_BY_ID[parent_id]
        if !has_carrier_id(parent_station)
          refute_equal parent_station["is_city"], "f", "The parent station #{parent_station["name"]} (#{parent_station["id"]}) has no carrier id and should be flagged as city"
        end
      end

      if children_list.size >= 2 &&
        parent_station["slug"] &&
        parent_station["parent_station_id"].nil? &&
        children_list.all? { |child| child["slug"] && child["slug"].start_with?(parent_station["slug"]) && child["slug"] != parent_station["slug"] }
          refute_equal parent_station["is_city"], "f", "The parent station #{parent_station["name"]} (#{parent_station["id"]}) should be a city"
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

  def test_parent_has_main_sation
    CHILDREN.each do |parent_id, children_list|
      parent_station = STATIONS_BY_ID[parent_id]
      if children_list.size >= 2 &&
        parent_station["is_suggestable"] == "t" &&
        parent_station["is_main_station"] == "f" &&
        parent_station["parent_station_id"].nil?

          main_station_count = children_list.select { |child| child["is_main_station"] == "t" }.size
          assert_equal 1, main_station_count, "The parent station #{parent_station["name"]} (#{parent_station["id"]}) should have one and only one main station"
      end
    end
  end

  def test_main_station_must_be_parent_or_child
    STATIONS.each do |row|
      if row["is_main_station"] == "t"
        is_parent_or_child = CHILDREN[row["id"]].size > 0 || row["parent_station_id"]
        assert is_parent_or_child, "The station #{row["name"]} (#{row["id"]}) cannot be main station as it is not a parent or child station"
      end
    end
  end

  def test_slugify
    assert_equal slugify("Figueras/Figueres Vilafant Esp."), "figueras-figueres-vilafant-esp"
  end

  def test_unique_slugs
    unique_set = Set.new

    STATIONS.each do |row|
      if row["is_suggestable"] == "t"
        assert !unique_set.include?(row["slug"]), "Duplicated slug '#{row["slug"]}' for station #{row["id"]}"
        unique_set << row["slug"]
      end
    end
  end

  def test_correct_slugs
    STATIONS.each do |row|
      if row["name"]
        if !Constants::HOMONYM_STATIONS.include?(row["id"])
          assert_equal slugify(row["name"]), row["slug"], "Station #{row["id"]} (#{row["name"]}) has an incorrect slug"
        else
          suffixes = Constants::HOMONYM_SUFFIXES[row["country"]].join("|")
          assert_match(/\A#{slugify(row["name"])}-(#{suffixes})+\z/, row["slug"], "Station #{row["id"]} has an incorrect slug")
        end
      end
    end
  end

  def test_uic8_sncf
    STATIONS.each do |row|
      uic8_sncf = row["uic8_sncf"]
      uic = row["uic"]
      if !uic8_sncf.nil? && !Constants::UIC8_WHITELIST_IDS.include?(row["id"])
        assert uic == uic8_sncf[0...-1], "Station #{row["id"]} have an incoherent uic8_sncf code"
      end
    end
  end


  def test_station_should_be_same_as
    STATIONS.each do |row|
      if row["is_suggestable"] == "f" &&
        CHILDREN[row["id"]].empty? &&
        row["parent_station_id"].nil? &&
        ALIASES[row["id"]].empty? &&
        row["same_as"].nil? &&
        row["slug"]

        assert_equal 1, SLUG_COUNT["#{row["slug"]}_#{row["country"]}"],
          "Station #{row["name"]} (#{row["id"]}) can be an alias of a station with the same name"
      end
    end
  end

  def test_same_as_is_valid
    STATIONS.each do |row|
      if row["same_as"]
        assert_equal "f", row["is_suggestable"], "Station #{row["id"]} is an alias, yet it is suggestable"
        refute_equal row["same_as"], row["id"], "Station #{row["id"]} references itself as an alias station"

        actual_station = STATIONS_BY_ID[row["same_as"]]
        assert row["slug"].start_with?(actual_station["slug"]), "Station #{row["id"]} is an alias of a station with a different name"
        assert !actual_station.nil?, "Station #{row["id"]} is an alias of a station that does not exist"
      end
    end
  end

  def test_same_as_carrier_ids
    STATIONS.each do |row|
      if row["same_as"]
        actual_station = STATIONS_BY_ID[row["same_as"]]
        carrier_ids = Constants::CARRIER_IDS.keys.map { |carrier| "#{carrier}_id" }
        carrier_ids += ["uic", "uic8_sncf", "sncf_tvs_id", "trenitalia_rtvt_id"]
        carrier_ids.each do |carrier_id|
          if row[carrier_id]
            assert !actual_station[carrier_id].nil?, "Actual station #{actual_station["name"]} (#{actual_station["id"]}) has not a #{carrier_id} while its alias #{row["id"]} has one"
          end
        end
      end
    end
  end

  def test_sncf_self_service_machine
    STATIONS.each do |row|
      parent_id = row["parent_station_id"]
      if parent_id
        parent = STATIONS_BY_ID[parent_id]
        if row["name"] == parent["name"]
          assert_equal row["sncf_self_service_machine"], parent["sncf_self_service_machine"], "Child station #{row["id"]} and parent station #{parent["id"]} named #{row["name"]} should have the same SNCF self-service machine information"
        end
      end

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
end
