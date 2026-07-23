# check_vspheredb_data

An Icinga check plugin to check the performance data gathered by the [Icingaweb2 vSphereDB module](https://github.com/icinga/icingaweb2-module-vspheredb).

It allows for monitoring of ESXI hosts on Icinga2's side without the need to configure alerting on the vCenters' side as vSphereDB's inbuilt mechanisms do.

## Installation

You can install the plugin from our official package server [packages.netways.de](https://packages.netways.de).

Installation guides for the repository can be found here:

RHEL: [Plugins/EPEL](https://packages.netways.de/plugins/epel/)

Debian: [Plugins/DEB](https://packages.netways.de/plugins/debian/)

Ubuntu: [Plugins/Ubuntu](https://packages.netways.de/plugins/ubuntu/)

After that install the package via your package manager:

**RHEL:**

`sudo dnf install netways-plugins-vspheredb-data`

**Debian/Ubuntu:**

`sudo apt install netways-plugins-vspheredb-data`

Or download a Release binary for your system's architecture from the [Releases](https://github.com/NETWAYS/check_vspheredb_data/releases) page.

## Usage

```
Available Commands:
  completion  Generate the autocompletion script for the specified shell
  cpu         Checks the current CPU usage
  datastore   Checks all datastores or a single specified datastore
  hba         Checks attached HBAs. Uses negative thresholds as parameters, e.g. 10:
  help        Help about any command
  memory      Checks the current memory usage
  nic         Checks the number of attached NICs. Uses negative thresholds as parameters, e.g. 10:
  temperature Checks the temperature of sensors

Flags:
  -f, --credentials-file string   Path to the credentials file
  -d, --database string           Database name (default "vspheredb")
  -h, --help                      help for check_vspheredb_data
  -H, --host string               Database host to connect to
  -m, --machine string            Machine to be queried for
  -P, --password string           Database password (default "vspheredb")
  -p, --port int16                Database port to connect to (default 3306)
  -u, --username string           Database username (default "vspheredb")

  datastore:
    --datastore string            Name of the datastore to check
  temperature:
    --sensor string               Sensor name filter (supports SQL LIKE pattern)
```

## Development

To build the tool yourself using the Golang toolchain:

```shell
git clone https://github.com/NETWAYS/check_vspheredb_data
cd check_vspheredb_data
go build
```

The repository contains example SQL data to test the plugin against:

```
podman run -ti --rm -p 3306:3306 \
  -e MYSQL_DATABASE=example -e MYSQL_USER=example -e MYSQL_PASSWORD=example -e MYSQL_ROOT_PASSWORD=example \
  -v $(pwd)/testdata/:/docker-entrypoint-initdb.d docker.io/mariadb:latest
```
## License

Copyright© 2024 [NETWAYS GmbH](mailto:info@netways.de)

This check plugin is distributed under the GPL-3.0 license shipped with this repository in the [LICENSE](LICENSE) file.
