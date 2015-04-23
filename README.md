## Description

[Capitaine Train](https://www.capitainetrain.com) sells tickets for numerous train operators across Europe.

This repository contains the information Capitaine Train uses to identify stations across the diverse systems of the train operators.

If you want to contribute to this database, please read [CONTRIBUTING.md](https://github.com/capitainetrain/stations/blob/master/CONTRIBUTING.md).

## Licence

The file `stations.csv` is distributed under the ODbL licence, see [LICENCE.txt](https://github.com/capitainetrain/stations/blob/master/LICENCE.txt). In short, any modification to this data source must be published.

Data sources include [OpenStreetMap](https://www.openstreetmap.org) and [SNCF OpenData](https://ressources.data.sncf.com/explore/dataset/referentiel-gares-voyageurs/), both released under ODbL or compatible licences; and a lot of blood, sweat, and tears.

## The Data

The file `stations.csv` contains all our data representing train stations. The file is UTF-8 encoded text file and Comma Separated Value (CSV) formatted – although a semi-colon `;` is used to delimitate fields.

### Columns

Column Name | Notes
----------- | -----
`id` | Internal unique identifier.
`name` | Name of the station as it is locally known; see `info_*` for translations.
`slug` | Guaranteed to be unique across all the _suggestable_ stations; see `is_suggestable`.
`uic` | The UIC code of the station.
`uic8_sncf` | SNCF sometimes uses an UIC code with 8 digits instead of 7. The last digit is a checksum.
`longitude` | Coordinates as decimal value.
`latitude` | Coordinates as decimal value.
`parent_station_id` | A station can belong to a _meta station_ whose `id` is this value, i.e. _Paris Gare d’Austerlitz_ belongs to the metastation _Paris_.
`is_city` | This value is unreliable.
`country` | 2 letters, [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
`is_main_station` | This value is unreliable.
`time_zone` | [Continent/Country ISO codes](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
`is_suggestable` | Can the user input this station.
`same_as` | Some systems allow stations to be split in two, with two `id` values. If provided, the station identified by the given value should be considered as the actual station.

#### Operator Specific

Operator specific columns contain identifiers and values specific to the operator. Columns are prefixed with a name unique to the operator.

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
`idbus_id` |
`idbus_is_enabled` |
`ouigo_id` |
`ouigo_is_enabled` |
`trenitalia_id` |
`trenitalia_is_enabled` |
`ntv_id` |
`ntv_is_enabled` |

#### Internationalisation

Language specific `info` columns contain translations of the station name. The language used is suffixed as an [ISO 639-1:2002](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) code.

Column Name | Notes
----------- | -----
`info:`* | Extra information that is useful in the specific language.
`info:fr` |
`info:en` |
`info:de` |
`info:it` |

## Tests

```bash
bundle install
ruby test_data.rb
```
