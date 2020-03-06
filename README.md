[![goodtables.io](https://goodtables.io/badge/github/n0rdlicht/toolbox-municipalities.svg)](https://goodtables.io/github/n0rdlicht/toolbox-municipalities)

# Swiss Municipalities

> This repository is part of the Smartuse Toolbox

> Background and data processing: [github.com/smartuse/toolbox-municipalities](https://github.com/smartuse/toolbox-municipalities)

This repository compiles tools to generate a Frictionless Data compliant Datapackage of the current Swiss municipalities in CSV, JSON and GeoJSON formats.

To add new datasets or make modifications, please visit our [GitHub repository](https://github.com/smartuse/toolbox-municipalities) and contact us via Issues or Pull Request.

Published on [Datahub](https://datahub.io/n0rdlicht/ch-municipalities/).
Validated on [GoodTables](https://goodtables.io)

## Prerequisites

To generate the CSV files you need to install Node.js, either with the official Node.js installer or via Homebrew:

    brew install node

You also need GDAL and the corresponding python-gdal library installed. On OS X you can also use Homebrew:

    brew install gdal

Now, clone this reposiory and run `make`

    git clone https://github.com/smartuse/toolbox-municipalities.git
    cd toolbox-municipalities
    npm install
    make

The downloads, build and the data folders should now be populated with processes files.

* `data/gemeinden.geojson` is generated first
* `data/gemeinden.csv` is derived from the `geojson`
* `data/gemeinden.json` is then derived from the `csv` version

## Push to Datahub

In order to push to Datahub, you need the [CLI Datahub Tools](https://docs.datahub.io/publishers/cli/) installed. They are part of the npm package dependencies, so should already be installed when you ran `npm install` earlier.

Verify that the new package validates

    data validate

Then you can update the list by

    data push

## Copyright and License

## Author

Thorben Westerhuys, SmartUse GmbH

## Datapackage

This package is licensed by its maintainers under the Public Domain Dedication and License.

If you intended to use these data in a public or commercial product, please check the data sources themselves for any specific restrictions.

## Geodata

Data source is the Swiss Federal Office of Topography, swissBOUNDARIES3D.

### License

Geodata from swisstopo is licensed under the Licence for the free geodata of the Federal Office of Topography swisstopo
