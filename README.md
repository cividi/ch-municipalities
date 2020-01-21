# Swiss Municipalities

> This repository is part of the Smartuse Toolbox

This repository compiles tools to generate a Frictionless Data compliant Datapackage of the current Swiss municipalities in CSV and JSON formats. 

Published on [Datahub](https://datahub.io/n0rdlicht/ch-municipalities/v/1).

## Prerequisites

To convert csv's to json the npm dependency [`csvtojson`](https://github.com/Keyang/node-csvtojson) is used. Hence start by executing

    git clone https://github.com/smartuse/toolbox-municipalities.git
    cd toolbox-municipalities
    npm install
    make

Now a downloads, build and the data folders should be populated.

* `data/gemeinden.csv` contains a list of municipalities
* `data/gemeinden.json` is the same list as nested JSON

## Push to Datahub

In order to push to Datahub, you need the [CLI Datahub Tools](https://docs.datahub.io/publishers/cli/) installed. 

Verify that the new package validates

    data validate

Then you can update the list by

    data push
