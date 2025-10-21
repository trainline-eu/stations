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
    "4089",  # Genève Voyageurs
    "9209",  # Bettembourg Frontière
    "17098", # Port-Bou
  ]

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

  # UIC Leaflet 920-14
  COUNTRIES_UIC_CODES = {
    "FI" => ["10"],
    "RU" => ["20"],
    "BY" => ["21"],
    "UA" => ["22"],
    "MD" => ["23"],
    "LT" => ["24"],
    "LV" => ["25"],
    "EE" => ["26"],
    "KZ" => ["27"],
    "GE" => ["28"],
    "UZ" => ["29"],
    "KP" => ["30"],
    "MN" => ["31"],
    "VN" => ["32"],
    "CN" => ["33"],
    "LA" => ["34"],
    "CU" => ["40"],
    "AL" => ["41"],
    "JP" => ["42"],
    "BA" => ["44", "49", "50"],
    "PL" => ["51"],
    "BG" => ["52"],
    "RO" => ["53"],
    "CZ" => ["54"],
    "HU" => ["55"],
    "SK" => ["56"],
    "AZ" => ["57"],
    "AM" => ["58"],
    "KG" => ["59"],
    "IE" => ["60"],
    "KR" => ["61"],
    "ME" => ["62"],
    "MK" => ["65"],
    "TJ" => ["66"],
    "TM" => ["67"],
    "AF" => ["68"],
    "GB" => ["70"],
    "ES" => ["71"],
    "RS" => ["72"],
    "GR" => ["73"],
    "SE" => ["74"],
    "TR" => ["75"],
    "NO" => ["76"],
    "HR" => ["78"],
    "SI" => ["79"],
    "DE" => ["80"],
    "AT" => ["81"],
    "LU" => ["82"],
    "IT" => ["83"],
    "NL" => ["84"],
    "CH" => ["85"],
    "DK" => ["86"],
    "FR" => ["87"],
    "BE" => ["88"],
    "TZ" => ["89"],
    "EG" => ["90"],
    "TN" => ["91"],
    "DZ" => ["92"],
    "MA" => ["93"],
    "PT" => ["94"],
    "IL" => ["95"],
    "IR" => ["96"],
    "SY" => ["97"],
    "LB" => ["98"],
    "IQ" => ["99"],
  }

  UIC_KNOWN_DISCREPANCIES = [
    "17", # Vievola 8300618 (FR)
    "811", # Basel SBB 8718791 (CH)
    "972", # Kehl Grenze 8721291 (DE)
    "1121", # Tournai Frontière 8724164 (BE)
    "1122", # Froyennes 8724175 (BE)
    "1143", # Aéroport Paris Roissy Charles de Gaulle CDG 9903148 (FR)
    "1313", # Mouscron 8728698 (BE)
    "1354", # Quevy Frontière 8729592 (BE)
    "1544", # Irún 8767791 (ES)
    "2848", # Le Locle Col des Roches 8759821 (CH)
    "3235", # Canfranc 8767290 (ES)
    "3600", # Vallorbe Frontière 8771591 (CH)
    "4041", # Le Trétien 8774663 (CH)
    "4042", # Les Marécottes 8774664 (CH)
    "4043", # Salvan 8774665 (CH)
    "4044", # Vernayaz 8774666 (CH)
    "4045", # Martigny 8774668 (CH)
    "4089", # Genève Voyageurs 8774890 (CH)
    "4091", # Lausanne 8774896 (CH)
    "4621", # Le Châtelard 8501382 (FR)
    "4656", # Le Locle 8705982 (CH)
    "4831", # Finhaut Frontière 8774662 (CH)
    "4930", # Port-Bou 8778590 (ES)
    "5671", # Ventimiglia Frontière 8775690 (IT)
    "6312", # Évian-les-Bains Port 8501074 (FR)
    "6994", # Salzburg 8020060 (AT)
    "7685", # Mittenwald 8103332 (DE)
    "8234", # Glasgow 9900008 (GB)
    "8267", # London 9900007 (GB)
    "9209", # Bettembourg Frontière 8719197 (LU)
    "9864", # Luxembourg 8713244 (LU)
    "10029", # Le Locle 8759822 (CH)
    "10433", # Hanweiler Grenze 8719392 (DE)
    "10439", # Rodange Frontière 8719494 (LU)
    "10491", # Warszawa 9900001 (PL)
    "10994", # Apach (fr) 8025197 (FR)
    "11147", # Beringen Bad Bf 8014484 (CH)
    "11740", # Forbach (fr) 8025396 (FR)
    "12098", # Herblingen 8014487 (CH)
    "12281", # Venlo (Gr) 8015134 (NL)
    "12859", # Neuhausen Bad Bf 8014485 (CH)
    "13231", # Riehen Niederholz 8087021 (CH)
    "13590", # Thayngen 8014490 (CH)
    "13603", # Trasadingen 8014488 (CH)
    "13833", # Wilchingen-Hallau 8014482 (CH)
    "14563", # Vejprty (Gr) 8009874 (CZ)
    "17098", # Portbou 8778595 (ES)
    "18256", # Lottstetten 8503420 (DE)
    "18257", # Jestetten 8503421 (DE)
    "22022", # Modane Gare 8300253 (FR)
    "22357", # San Martino 8354406 (CH)
    "24439", # Tánger Med-Barco 7199124 (MA)
    "24440", # Tánger Ville-Barco 7199125 (MA)
    "28674", # Nikšić 7231101 (ME)
    "28688", # Bijelo Polje 7231302 (ME)
    "28689", # Mojkovac 7231305 (ME)
    "28690", # Podgorica 7231001 (ME)
    "28691", # Bar 7231080 (ME)
    "28692", # Kolašin 7231307 (ME)
    "28696", # Grobelno 7243200 (SI)
    "28697", # Opatija-Matulji 7244911 (HR)
    "28698", # Pula 7244417 (HR)
    "28699", # Banja Luka 7253127 (BA)
    "28700", # Bihać 7253408 (BA)
    "28701", # Bos Krupa 7213093 (BA)
    "28702", # Bosanski Novi 7253160 (BA)
    "28703", # Čapljina 7251047 (BA)
    "28704", # Doboj 7252060 (BA)
    "28705", # Licka Kaldrma 7253423 (HR)
    "28706", # Martin Brod 7253418 (BA)
    "28707", # Ploče 7251080 (HR)
    "28708", # Podlugovi 7252087 (BA)
    "28710", # Prijedor 7253107 (BA)
    "28711", # Tuzla 7213166 (BA)
    "28712", # Zavidovići 7252029 (BA)
    "28713", # Zenica 7252062 (BA)
    "28714", # Bitola 7261822 (MK)
    "28715", # Demir Kapija 7261711 (MK)
    "28716", # Negotino Vardar 7261708 (MK)
    "28717", # Prilep 7261815 (MK)
    "28719", # Kićevo 7261519 (MK)
    "28720", # Veles 7261601 (MK)
    "28723", # Kumanovo 7261203 (MK)
    "51453", # Mals/Malles Abzw Schleis 8583439 (IT)
    "61115", # Stabio 8313709 (CH)
    "61116", # Col-du-Pillon Glacier 3000 8313926 (CH)
  ]

  RAIL_IDS = {
    "atoc_id"              => '([A-Z]{3}|[0-9]{1,3})',                  # ABC, 1, 12, 123
    "benerail_id"          => '[A-Z]{5}',                               # ABCDE
    "busbud_id"            => '[0-9a-f]{32}',                           # a732ca8fe3bf44eeae55c2b5613e3bd9
    "cff_id"               => '[0-9]{3,7}',                             # 1234567
    "db_id"                => '[0-9]{6,7}',                             # 123456, 1234567
    "distribusion_id"      => '@*[A-Z]{5,8}',                           # FRPAR, FRPARCDG, @FRPARCDGT1
    "flixbus_id"           => '[0-9]{2,6}',                             # 1234
    "entur_id"             => 'NSR|[a-zA-Z]|[0-9]',                     # NSR|StopPlace|11267
    "ntv_id"               => '[A-Z][A-Z_0-9]{2}',                      # A__, AB_, AB0, ABC, AB2
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
    "cercanias",
    "cff",
    "db",
    "distribusion",
    "entur",
    "flixbus",
    "ntv",
    "obb",
    "renfe",
    "sncf",
    "trenitalia",
    "westbahn",
  ]

  BOOLEAN_COLUMNS = CARRIERS.map { |carrier| "#{carrier}_is_enabled" }
  BOOLEAN_COLUMNS.push(
    "country_hint",
    "is_airport",
    "is_city",
    "is_main_station",
    "is_suggestable",
    "main_station_hint",
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
    "35841" # Sant Pol de Mar
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
    "5973",  # Brugge / Bruges
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
    "5893", # Bruxelles-Midi - Distribusion - European Sleeper (train)
    "5894", # Amsterdam-Centraal - Distribusion - European Sleeper (train)
    "5929", # Antwerpen-Centraal - Distribusion - European Sleeper (train)
    "7519", # Dresden Hbf - Distribusion - European Sleeper (train)
    "7540", # Berlin Ostbahnhof - Distribusion - European Sleeper (train)
    "7630", # Berlin Hbf - Distribusion - European Sleeper (train)
    "8644", # Den Haag HS - Distribusion - European Sleeper (train)
    "8670", # Rotterdam Centraal - Distribusion - European Sleeper (train)
    "17509", # Praha hl.n. - Distribusion - European Sleeper (train)
    "17511", # Ústí nad Labem hl.n.Distribusion - European Sleeper (train)
    "74653", # Amersfoort Central Train Station - Distribusion - European Sleeper (train)
    "74660", # Taranto Terminal Cimino
    "74661", # Firenze Piazzale Montelungo
    "8673", # Utrecht Centraal - Distribusion - European Sleeper (train)
    "28958", # Malpensa Airport T2
  ]
end
