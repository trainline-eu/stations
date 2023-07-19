module Constants
  CSV_PARAMETERS = {
    :headers    => true,
    :col_sep    => ';',
    :encoding   => 'UTF-8'
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
    "nb",
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

  UIC8_WHITELIST_IDS = ["1144"] # Exception : CDG TGV UIC8 is CDG 2 RER.

  HOMONYM_SUFFIXES = {
    "BE" => ["station", "gare"],
    "BG" => ["gara"],
    "CH" => ["bahnhof", "gare", "stazione"],
    "DE" => ["bahnhof", "stadt"],
    "EE" => ["station"],
    "ES" => ["estacion", "ciudad"],
    "FR" => ["gare"],
    "GB" => ["station"],
    "GR" => ["stathmo", "poli"],
    "HR" => ["stanica"],
    "IT" => ["stazione"],
    "NL" => ["station"],
    "NO" => ["stasjon"],
    "PT" => ["estacao"],
    "SI" => ["postaja"],
    "RO" => ["autogara"],
  }
  DUPLICATE_STATION_SUFFIXES = ["bis"]

  COUNTRIES = {
    "AD" => "Europe/Paris",
    "AL" => "Europe/Tirane",
    "AT" => "Europe/Vienna",
    "BA" => "Europe/Sarajevo",
    "BE" => "Europe/Brussels",
    "BG" => "Europe/Sofia",
    "BY" => "Europe/Minsk",
    "CH" => "Europe/Zurich",
    "CY" => "Asia/Nicosia",
    "CZ" => "Europe/Prague",
    "DE" => "Europe/Berlin",
    "DK" => "Europe/Copenhagen",
    "EE" => "Europe/Tallinn",
    "ES" => "Europe/Madrid",
    "FI" => "Europe/Helsinki",
    "FR" => "Europe/Paris",
    "GB" => "Europe/London",
    "GR" => "Europe/Athens",
    "HR" => "Europe/Zagreb",
    "HU" => "Europe/Budapest",
    "IE" => "Europe/Dublin",
    "IT" => "Europe/Rome",
    "LI" => "Europe/Vaduz",
    "LT" => "Europe/Vilnius",
    "LU" => "Europe/Luxembourg",
    "LV" => "Europe/Riga",
    "MA" => "Africa/Casablanca",
    "MD" => "Europe/Chisinau",
    "ME" => "Europe/Podgorica",
    "MK" => "Europe/Skopje",
    "MT" => "Europe/Malta",
    "NL" => "Europe/Amsterdam",
    "NO" => "Europe/Oslo",
    "PL" => "Europe/Warsaw",
    "PT" => "Europe/Lisbon",
    "RO" => "Europe/Bucharest",
    "RS" => "Europe/Belgrade",
    "RU" => "Europe/Moscow",
    "SE" => "Europe/Stockholm",
    "SI" => "Europe/Ljubljana",
    "SK" => "Europe/Bratislava",
    "SR" => "Europe/Belgrade",
    "TR" => "Europe/Istanbul",
    "UA" => "Europe/Kiev"
  }

  RAIL_IDS = {
    "atoc_id"              => '([A-Z]{3}|[0-9]{1,3})',                  # ABC, 1, 12, 123
    "benerail_id"          => '[A-Z]{5}',                               # ABCDE
    "busbud_id"            => '[a-z0-9]{6}',                            # a1b2cd
    "cff_id"               => '[0-9]{7}',                               # 1234567
    "db_id"                => '[0-9]{6,7}',                             # 123456, 1234567
    "distribusion_id"      => '@*[A-Z]{5,8}',                           # FRPAR, FRPARCDG, @FRPARCDGT1
    "flixbus_id"           => '[0-9]{2,6}',                             # 1234
    "hkx_id"               => '[0-9]{9}',                               # 123456789
    "entur_id"             => 'NSR|[a-zA-Z]|[0-9]',                     # NSR|StopPlace|11267
    "leoexpress_id"        => '([0-9]+|[A-Z]+)',                        # 841, 5615750, PRAHA, SOMETOWN
    "ntv_id"               => '[A-Z][A-Z_0]{2}',                        # A__, AB_, AB0, ABC
    "ntv_rtiv_id"          => '[0-9]{3,4}',                             # 123, 1234
    "obb_id"               => '[0-9]{6,7}',                             # 123456, 1234567
    "ouigo_id"             => '[A-Z]{2}[A-Z1]|[A-Z]{5}',                # ABC, AB1, FRABC
    "renfe_id"             => '([0-9]{5}[0-9]{2}?|[A-Z]{3}[A-Z -]{2})', # 12345, 1234567, ABCDE, ABC D, ABCD-
    "sncf_id"              => '[A-Z]{5}',                               # AZERT
    "sncf_tvs_id"          => '[A-Z]{3}(_TRANS|_PSL)?',                 # ABC, ABC_TRANS, ABC_PSL
    "trenitalia_id"        => '[0-9]{7}',                               # 1234567
    "trenitalia_rtvt_id"   => '[NS][0-9]{5}',                           # N12345, S12345
    "uic"                  => '[0-9]{7}',                               # 1234567
    "uic8_sncf"            => '[0-9]{8}',                               # 12345678
    "westbahn_id"          => '[0-9]{1,3}',                             # 12345
  }

  CARRIERS = [
    "atoc",
    "benerail",
    "busbud",
    "cff",
    "db",
    "distribusion",
    "entur",
    "flixbus",
    "hkx",
    "leoexpress",
    "ntv",
    "obb",
    "ouigo",
    "renfe",
    "sncf",
    "trenitalia",
    "westbahn",
  ]

  BOOLEAN_COLUMNS = CARRIERS.map { |carrier| "#{carrier}_is_enabled" }
  BOOLEAN_COLUMNS.push(
    "is_city",
    "is_main_station",
    "is_suggestable",
    "sncf_self_service_machine"
  )

  ALLOWED_COMBINATIONS_WITH_DOT = [
    '(^| |-)St.(-| |$)',     # Acronym of "station" and "saint"
    ' L.T.$',                # British stations
    ' (hl.|sev.)?n.( |$)',   # Czech stations
    ' hl.st.( |$)',          # Czech stations
    ' F.C.$',                # Italian stations
    ' A.L.$',                # Italian stations
    ' i.E.',                 # Swiss stations
  ]

  ALLOWED_STATIONS_WITH_DOT = [
    "9964",         # Paris-S.URB.M.
    "18768",        # Nykøbing Falster Rtb. (Bus)
    "22579",        # Pisa San Rossore T.
    "25543",        # I.B.M.
    "34294",        # P. Rocamora
  ]

  # System id defined in a private file
  # These ids should be there temporarly
  STATIONS_ENABLED_ELSEWHERE = [
    "10045", # Orly Ouest
    "10047", # Orly Sud
    "29297", # Roissy T2 A-C
    "29298", # Roissy T2 B-D
    "29299", # Roissy T2 E-F
    "29300", # Roissy T1
    "23599", # Porte Maillot
    "29301", # Etoile Champs Elysées
  ]

  # Not real technical limitation, but we have to ensure that there is no infinite loop
  # And a tree too deep could reveal station organisation issues
  PARENTHOOD_TREE_MAX_DEPTH = 8

  AIRPORT_TRANSLATIONS = {
    :fr => 'aeroport',
    :en => 'airport',
    :de => 'flughafen',
    :es => 'aeropuerto',
    :it => 'aeroporto',
    :nl => 'luchthaven',
    :da => 'lufthavn',
    :ru => 'аэропорт',
    # to be completed with other languages
  }

  MAIN_STATION_TRANSLATIONS = {
    :de => "hauptbahnhof",
    :en => "main station",
    :es => "estación central",
    :fr => "gare centrale",
    :it => "stazione centrale",
    # to be completed with other languages
  }

  BUS_PRECISE_STATION = [
    "840",   # Belfort-Ville
    "4757",  # Marne-la-Vallée—Chessy
    "4920",  # Paris Montparnasse
    "4924",  # Paris Gare de Lyon
    "6165",  # Martigny
    "6247",  # Lausanne
    "6349",  # Neuchâtel
    "6352",  # St-Gallen
    "6943",  # Frankfurt (M) Flughafen
    "8575",  # Venezia Mestre
    "8604",  # Luxembourg
    "9446",  # La Défense
    "19571", # Diano Marina
    "22525", # Bellaria
    "23599", # Paris Porte Maillot
    "29301", # Paris Étoile - Champs Élysées
    "8672",  # Amsterdam Schiphol Airport
    "7681",  # Munich Airport
    "16130", # Munich Airport
    "32267", # Frankfurt Hahn
    "34612", # Munich Airport
    "34613", # Munich Airport
    "34620", # Brindisi Airport
    "35406", # Alghero Airport
    "35409", # Barcelona El Prat
    "35410", # Barcelona El Prat
    "38698", # Vnukovo Airport Train Station
    "38699", # Moscow Domodedovo Airport Train Station
    "38700", # Moscow Sheremetyevo Airport Train Station
    "6992", # Passau Hbf
    "7131", # Neuenburg (Baden)
    "7366", # Pocking
    "7667", # Kaiserslautern Hbf
    "16631", # Berlin Nordbahnhof
    "18817", # Györ
    "22273", # Turin Airport
  ]
end
