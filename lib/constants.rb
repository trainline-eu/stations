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
    "23189", # Neufchâteau (Belgium & France)
    "23759", # Bellavista (Spain and Italy)
    "24394", # Santa Lucia (Spain and Italy)
    "24424", # Silla (Spain and Italy)
    "24457", # Torralba (Spain and Italy)
    "25153", # Dormans (England and France)
    "25481", # Hever (Belgium and England)
    "26735", # Enfield (England and Ireland)
    "26759", # Malling (France and England)
    "17741", # Essen (Belgium and Germany)
    # "27486", # Arce (Spain and Italy),
    # "27488", # Breda (Spain and Netherlands)
    # "27489", # Pau (Spain and France)
  ]

  UIC8_WHITELIST_IDS = ["1144"] # Exception : CDG TGV UIC8 is CDG 2 RER.

  HOMONYM_SUFFIXES = {
    "BE" => ["station", "gare"],
    "CH" => ["bahnhof", "gare", "stazione"],
    "DE" => ["bahnhof"],
    "ES" => ["estacion", "ciudad"],
    "FR" => ["gare"],
    "GB" => ["station"],
    "IT" => ["stazione"],
    "NL" => ["station"],
    "NO" => ["stasjon"],
    "PT" => ["estacao"],
  }

  COUNTRIES = {
    "AD" => "Europe/Paris",
    "AT" => "Europe/Vienna",
    "BA" => "Europe/Sarajevo",
    "BE" => "Europe/Brussels",
    "BG" => "Europe/Sofia",
    "BY" => "Europe/Minsk",
    "CH" => "Europe/Zurich",
    "CZ" => "Europe/Prague",
    "DE" => "Europe/Berlin",
    "DK" => "Europe/Copenhagen",
    "ES" => "Europe/Madrid",
    "FI" => "Europe/Helsinki",
    "FR" => "Europe/Paris",
    "GB" => "Europe/London",
    "GR" => "Europe/Athens",
    "HR" => "Europe/Zagreb",
    "HU" => "Europe/Budapest",
    "IE" => "Europe/Dublin",
    "IT" => "Europe/Rome",
    "LT" => "Europe/Vilnius",
    "LU" => "Europe/Luxembourg",
    "LV" => "Europe/Riga",
    "MA" => "Africa/Casablanca",
    "ME" => "Europe/Podgorica",
    "MK" => "Europe/Skopje",
    "NL" => "Europe/Amsterdam",
    "NO" => "Europe/Oslo",
    "PL" => "Europe/Warsaw",
    "PT" => "Europe/Lisbon",
    "RO" => "Europe/Bucarest",
    "RS" => "Europe/Belgrade",
    "RU" => "Europe/Moscow",
    "SE" => "Europe/Stockholm",
    "SI" => "Europe/Ljubljana",
    "SK" => "Europe/Bratislava",
    "TR" => "Europe/Istanbul",
    "UA" => "Europe/Kiev"
  }

  RAIL_IDS = {
    "atoc_id"              => '([A-Z]{3}|[0-9]{1,3})',                  # ABC, 1, 12, 123
    "benerail_id"          => '[A-Z]{5}',                               # ABCDE
    "busbud_id"            => '[a-z0-9]{6}',                            # a1b2cd
    "db_id"                => '[0-9]{6,7}',                             # 123456, 1234567
    "flixbus_id"           => '[0-9]{2,5}',                             # 1234
    "hkx_id"               => '[0-9]{9}',                               # 123456789
    "idtgv_id"             => '[A-Z]{2}[A-Z1]',                         # ABC, AB1
    "ntv_id"               => '[A-Z][A-Z_0]{2}',                        # A__, AB_, AB0, ABC
    "ntv_rtiv_id"          => '[0-9]{3,4}',                             # 123, 1234
    "ouigo_id"             => '[A-Z]{2}[A-Z1]',                         # ABC, AB1
    "renfe_id"             => '([0-9]{5}[0-9]{2}?|[A-Z]{3}[A-Z -]{2})', # 12345, 1234567, ABCDE, ABC D, ABCD-
    "sncf_id"              => '[A-Z]{5}',                               # AZERT
    "sncf_tvs_id"          => '[A-Z]{3}(_TRANS|_PSL)?',                 # ABC, ABC_TRANS, ABC_PSL
    "trenitalia_id"        => '[0-9]{7}',                               # 1234567
    "trenitalia_rtvt_id"   => '[NS][0-9]{5}',                           # N12345, S12345
    "uic"                  => '[0-9]{7}',                               # 1234567
    "uic8_sncf"            => '[0-9]{8}',                               # 12345678
  }

  CARRIERS = [
    "atoc",
    "benerail",
    "busbud",
    "db",
    "flixbus",
    "hkx",
    "idtgv",
    "leoexpress",
    "ntv",
    "ouigo",
    "renfe",
    "sncf",
    "trenitalia",
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
  ]

  ALLOWED_STATIONS_WITH_DOT = [
    "9964",         # Paris-S.URB.M.
    "18768",        # Nykøbing Falster Rtb. (Bus)
    "22579",        # Pisa San Rossore T.
    "25543",        # I.B.M.
  ]

  # System id defined in a private file
  # Most of these ids should be there temporary
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
end
