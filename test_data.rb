require "csv"
require "minitest/autorun"
require "set"
require "stringex"

parameters = {
  :headers   => true,
  :col_sep   => ';',
  :encoding => 'UTF-8'
}

LOCALES = [
  "fr",
  "en",
  "da",
  "de",
  "it",
  "cs",
  "es",
  "hu",
  "ja",
  "ko",
  "nl",
  "pl",
  "pt",
  "ru",
  "sv",
  "tr",
  "zh"
]

SUGGESTABLE_LOCALES = [
  "fr",
  "en",
  "de",
  "it",
  "es"
]

VIRTUAL_STATIONS = [
  "811",   # Basel SBB
  "972",   # Kehl Grenze
  "1354",  # Quevy Frontière
  "3600",  # Vallorbe Frontière
  "4089",  # Genève Voyageurs
  "4185",  # Limone Confine
  "4551",  # Le Châtelard Frontière
  "4930",  # Port-Bou
  "5671",  # Ventimiglia Frontière
  "9045",  # Les Verrières Frontière
  "9209",  # Bettembourg Frontière
  "9232",  # Jeumont Frontière
  "9282",  # Apach Frontière
  "9367",  # Blandain Frontière
  "9370",  # Tourcoing Frontière
  "9414",  # Modane Frontière
  "9619",  # Wannehain Frontière
  "10220", # Hendaye Frontière
  "10431", # Forbach Frontière
  "10433", # Hanweiler Grenze
  "10439"  # Rodange Frontière
]

HOMONYM_STATIONS = [
  "117",   # Forbach (France)
  "780",   # Ch[eè]vremont (France & the Netherlands)
  "5914",  # Statte (Belgium and Italy)
  "6661",  # Lugo (Spain and Italy)
  "8015",  # Hove (Belgium and England)
  "8210",  # Derby (Italy and England)
  "8720",  # Guarda (Portugal and Italy)
  "17958", # Comines (Belgium)
  "17989", # Lens (Belgium)
  "18164", # Melle (Belgium)
  "18006", # Leval (Belgium)
  "18024", # Herne (Belgium)
  "18894", # Borne (Netherlands)
  "18937", # Haren (Netherlands)
  "19016", # Soest (Netherlands)
  "19053", # Zwijndrecht (Netherlands)
  "11343", # Burgdorf (Germany)
  "21261", # Lison (Italy)
  "23759", # Bellavista (Spain and Italy)
  "24394", # Santa Lucia (Spain and Italy)
  "24424", # Silla (Spain and Italy)
  "24457", # Torralba (Spain and Italy)
  "25153", # Dormans (England and France)
  "25481", # Hever (Belgium and England)
  "26735", # Enfield (England and Ireland)
  "26759", # Malling (France and England)
  "17741", # Essen (Belgium and Germany)
  "27486", # Arce (Spain and Italy),
  "27488", # Breda (Spain and Netherlands)
  "27489", # Pau (Spain and France)
]

HOMONYM_SUFFIXES = {
  "BE" => ["station", "gare"],
  "CH" => ["bahnhof", "gare", "stazione"],
  "DE" => ["bahnhof"],
  "ES" => ["estacion", "ciudad"],
  "FR" => ["gare"],
  "GB" => ["station"],
  "IT" => ["stazione"],
  "NL" => ["station"],
  "PT" => ["estacao"],
}

COUNTRIES = {
  "AD" => "Europe/Paris",
  "AT" => "Europe/Vienna",
  "BE" => "Europe/Brussels",
  "BY" => "Europe/Minsk",
  "CH" => "Europe/Zurich",
  "CZ" => "Europe/Prague",
  "DE" => "Europe/Berlin",
  "DK" => "Europe/Copenhagen",
  "ES" => "Europe/Madrid",
  "FR" => "Europe/Paris",
  "GB" => "Europe/London",
  "HR" => "Europe/Zagreb",
  "HU" => "Europe/Budapest",
  "IE" => "Europe/Dublin",
  "IT" => "Europe/Rome",
  "LU" => "Europe/Luxembourg",
  "MA" => "Africa/Casablanca",
  "NL" => "Europe/Amsterdam",
  "PL" => "Europe/Warsaw",
  "PT" => "Europe/Lisbon",
  "RU" => "Europe/Moscow",
  "SE" => "Europe/Stockholm",
  "SI" => "Europe/Ljubljana",
  "SK" => "Europe/Bratislava"
}

STATIONS = CSV.read("stations.csv", parameters)
STATIONS_BY_ID = STATIONS.inject({}) { |hash, station| hash[station["id"]] = station; hash }
STATIONS_UIC8_WHITELIST_IDS = ["1144"] # Exception : CDG TGV UIC8 is CDG 2 RER.

CHILDREN = {}
CHILDREN_COUNT = Hash.new(0)
STATIONS.each { |row| CHILDREN[row["id"]] = [] }

def valid_carrier(row)
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

STATIONS.each do |row|
  if row["parent_station_id"]
    CHILDREN[row["parent_station_id"]] << row
    if valid_carrier(row) == "t"
      CHILDREN_COUNT[row["parent_station_id"]] += 1
    end
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

  def test_number_columns
    nb_columns = 57

    STATIONS.each { |row| assert_equal nb_columns, row.size, "Wrong number of columns #{row["size"]} for station #{row["id"]}" }
  end

  def validate_enabled_and_id_columns(carrier, id_column_size = nil)
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
        if id_column_size
          if id_column_size.is_a?(Array)

            assert id_column_size.include?(row[id_column].size), "Invalid #{id_column}: #{row[id_column]} for station #{row["id"]}"
          else
            assert_equal id_column_size, row[id_column].size, "Invalid #{id_column}: #{row[id_column]} for station #{row["id"]}"
          end
        end

        assert !unique_set.include?(row[id_column]), "Duplicated #{id_column} #{row[id_column]} for station #{row["id"]}"
        unique_set << row[id_column]
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

  def test_db_enabled_and_id_columns
    validate_enabled_and_id_columns("db")
  end

  def test_hkx_enabled_and_id_columns
    validate_enabled_and_id_columns("hkx")
  end

  def test_busbud_enabled_and_id_columns
    validate_enabled_and_id_columns("busbud", 6)
  end

  def test_idtgv_enabled_and_id_columns
    validate_enabled_and_id_columns("idtgv", 3)
  end

  def test_ntv_enabled_and_id_columns
    validate_enabled_and_id_columns("ntv", 3)
  end

  def test_ouigo_enabled_and_id_columns
    validate_enabled_and_id_columns("ouigo", 3)
  end

  def test_sncf_enabled_and_id_columns
    validate_enabled_and_id_columns("sncf", 5)
  end

  def test_trenitalia_enabled_and_id_columns
    validate_enabled_and_id_columns("trenitalia", 7)
  end

  def test_ntv_enabled_and_id_columns
    validate_enabled_and_id_columns("ntv", 3)
  end

  def test_renfe_enabled_an_id_columns
    validate_enabled_and_id_columns("renfe", [5, 7])
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
        assert_operator lon, :<, 39, "Coordinates of station #{row["id"]} not within the bounding box"
        assert_operator lat, :>, 35, "Coordinates of station #{row["id"]} not within the bounding box"
        assert_operator lat, :<, 68, "Coordinates of station #{row["id"]} not within the bounding box"
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

  def test_is_main_station
    STATIONS.each do |row|
      assert ["t", "f"].include?(row["is_main_station"]), "Invalid value for is_main_station for station #{row["id"]}"
    end
  end

  def test_country
    countries = COUNTRIES.keys
    STATIONS.each do |row|
      assert countries.include?(row["country"]), "Invalid value for country for station #{row["id"]}"
    end
  end

  def test_time_zone
    STATIONS.each do |row|
      timezone = COUNTRIES[row["country"]]
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
      if row["is_suggestable"] == "t" && !HOMONYM_STATIONS.include?(row["id"])
        assert !names.include?(row["name"]), "Duplicate name '#{row["name"]}'"

        names << row["name"]
      end
    end
  end

  def test_homonym_suggestable
    HOMONYM_STATIONS.each do |homonym_id|
      homonym_station = STATIONS_BY_ID[homonym_id]
      assert_equal homonym_station["is_suggestable"], "t", "Homonym station #{homonym_station["name"]} (#{homonym_station["id"]}) is not suggestable"
    end
  end

  def test_homonym_information
    HOMONYM_STATIONS.each do |homonym_id|
      homonym_station = STATIONS_BY_ID[homonym_id]
      SUGGESTABLE_LOCALES.each do |locale|
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

    HOMONYM_STATIONS.each do |homonym_id|
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
        LOCALES.each do |locale|
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
        assert valid_carrier(row) || CHILDREN[row["id"]].any? { |r| valid_carrier(r) },
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
        LOCALES.each do |locale|
          if !parent["info:#{locale}"].nil?
            assert !row["info:#{locale}"].nil?, "Station #{row["name"]} (#{row["id"]}) has no \“#{locale}\” info while its parent (#{parent["name"]}) has"
          end
        end
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
      if row["is_suggestable"] == "t"
        if !HOMONYM_STATIONS.include?(row["id"])
          assert_equal slugify(row["name"]), row["slug"], "Station #{row["id"]} (#{row["name"]}) has an incorrect slug"
        else
          suffixes = HOMONYM_SUFFIXES[row["country"]].join("|")
          assert_match(/\A#{slugify(row["name"])}-(#{suffixes})+\z/, row["slug"], "Station #{row["id"]} has an incorrect slug")
        end
      end
    end
  end

  def test_metastation_have_multiple_children
    CHILDREN_COUNT.each do |id, children_count|
      station = STATIONS_BY_ID[id]
      if station["is_suggestable"] == "t"
        assert children_count >= 2, "The meta station #{id} is suggestable and has only #{children_count} child"
      end
    end
  end

  def test_uic8_sncf
    STATIONS.each do |row|
      uic8_sncf = row["uic8_sncf"]
      uic = row["uic"]
      if !uic8_sncf.nil? && !STATIONS_UIC8_WHITELIST_IDS.include?(row["id"])
        assert uic == uic8_sncf[0...-1], "Station #{row["id"]} have an incoherent uic8_sncf code"
      end
    end
  end

  def test_same_as_is_valid
    STATIONS.each do |row|
      if row["same_as"]
        assert_equal "f", row["is_suggestable"], "Station #{row["id"]} is an alias, yet it is suggestable"

        actual_station = STATIONS_BY_ID[row["same_as"]]
        assert row["slug"].start_with?(actual_station["slug"]), "Station #{row["id"]} is an alias of a station with a different name"
        assert !actual_station.nil?, "Station #{row["id"]} is an alias of a station that does not exist"
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
    VIRTUAL_STATIONS.each do |id|
      station = STATIONS_BY_ID[id]
      assert_equal "t", station["sncf_is_enabled"], "Virtual station #{station["name"]} (#{station["id"]}) should be enabled for SNCF"
    end
  end
end
