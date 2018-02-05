[![Build Status](https://travis-ci.org/trainline-eu/stations.svg?branch=master)](https://travis-ci.org/trainline-eu/stations)

[Trainline EU](https://www.trainline.eu) sells tickets for numerous train operators across Europe.

## Stations - A Database of European Train Stations

This repository contains the information Trainline EU uses to identify stations across the diverse systems of the train operators.

If you want to contribute to this database, please read [CONTRIBUTING.md](https://github.com/trainline-eu/stations/blob/master/CONTRIBUTING.md).

## Licence

The file `stations.csv` is distributed under the Open Database License (ODbL) licence, see [LICENCE.txt](https://github.com/trainline-eu/stations/blob/master/LICENCE.txt). In short, any modification to this data source must be published.

Data come from the following sources:

- [OpenStreetMap](https://www.openstreetmap.org)
- [SNCF OpenData](https://ressources.data.sncf.com/explore/dataset/referentiel-gares-voyageurs/)
- [GeoNames](http://www.geonames.org/)
- [Digitraffic.fi](http://rata.digitraffic.fi/api/v1/metadata/stations)

All these sources were released under ODbL or compatible licences.

## Tests

If you're going to modify the file, don't forget to run the automated tests to ensure consistency of the information provided. This script is used in the build triggered by merge requests.

```bash
make install
make test
```

## The Data

The file `stations.csv` contains all our data representing train stations and cities. The file is UTF-8 encoded text file and Comma Separated Value (CSV) formatted – although a semi-colon `;` is used to delimitate fields. Boolean flags are represented with t/f (true/false) values.

### Columns

Column Name | Notes
----------- | -----
`id` | Internal unique identifier.
`name` | Name of the station as it is locally known; see `info_*` for translations.
`language` | Language in which the station name is provided  
`slug` | Guaranteed to be unique across all the _suggestable_ stations; see `is_suggestable`.
`uic` | The UIC code of the station.
`uic8_sncf` | SNCF sometimes uses an UIC code with 8 digits instead of 7. The last digit is a checksum.
`longitude` | Coordinates as decimal value.
`latitude` | Coordinates as decimal value.
`parent_station_id` | A station can belong to a _meta station_ whose `id` is this value, i.e. _Paris Gare d’Austerlitz_ belongs to the metastation _Paris_.
`country` | 2 letters, [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
`time_zone` | [Continent/Country ISO codes](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
`is_city` | This value is unreliable.
`is_main_station` | This value is unreliable.
`is_airport` | Specify if the station is related to an airport.
`is_suggestable` | Specify if the user can input this station.
`country_hint` | Specify if the country should be displayed to disambiguate the station's name.
`sncf_self_service_machine` | Presence of a SNCF self-service machine at the station.
`same_as` | Some systems allow stations to be split in two, with two `id` values. If provided, the station identified by the given value should be considered as the actual station.

#### Operator Specific

Operator specific columns contain identifiers and values specific to the operator. Columns are prefixed with a name unique to the operator. `rt*` columns are about ids used in realtime APIs.

Column Name | Notes
----------- | -----
*`_id` | id of the station as it is known by the carrier.
*`_is_enabled` | Can a ticket be booked to/from the station through that carrier?
`sncf_id` |
`sncf_is_enabled` |
`idtgv_id` |
`idtgv_is_enabled` |
`db_id` |
`db_is_enabled` |
`hkx_id` |
`hkx_is_enabled` |
`busbud_id` |
`busbud_is_enabled` |
`flixbus_id` |
`flixbus_is_enabled` |
`leoexpress_id` |
`leoexpress_is_enabled` |
`ouigo_id` |
`ouigo_is_enabled` |
`trenitalia_id` |
`trenitalia_is_enabled` |
`trenitalia_rtvt_id` |
`ntv_id` |
`ntv_is_enabled` |
`ntv_rtiv_id` |
`hkx_id` |
`hkx_is_enabled` |
`renfe_id` |
`renfe_is_enabled` |
`atoc_id` |
`atoc_is_enabled` |
`benerail_id` |
`benerail_is_enabled` |

#### Internationalisation

Language specific `info:xx` columns contain translations. The language used is suffixed as an [ISO 639-1:2002](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) code.

Column Name | Notes
----------- | -----
`info:`* | Extra information that is useful in the specific language.
`info:fr` |
`info:en` |
`info:de` |
`info:it` |


## Productivity tools

#### For internationalisation

To facilitate the internationalisation of city names, we use and maintain a script querying [Geonames API](http://www.geonames.org/) to look for city name translations.

The project is hosted [on Github](https://github.com/mgalibert/geonames) and contains its own documentation.
