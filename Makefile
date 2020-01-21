CKAN_Endpoint = "https://opendata.swiss/api/3/"
# action/package_show?id=
PKG_ID = swissboundaries3d_gemeindegrenzen
FILE_NAME = swissBOUNDERIES3D

.PHONY: all

all: data/gemeinden.json

data/gemeinden.json: data/gemeinden.csv
	mkdir -p $(dir $@)
	cat $< | node_modules/.bin/csvtojson > $@

data/gemeinden.csv: build/gemeinden-clean.gpkg
	mkdir -p $(dir $@)
	ogr2ogr -f CSV $@ $<

build/gemeinden-clean.gpkg: build/gemeinden.gpkg
	ogr2ogr -f GPKG $@ $< -sql 'select distinct `gemeinde.BFS_NUMMER`,`gemeinde.NAME`,`kanton.KUERZEL`,`kanton.NAME` from gemeinde'

build/gemeinden.gpkg: src/kantone.csv
	ogr2ogr -f GPKG -sql "select gemeinde.*, kanton.* from swissBOUNDARIES3D_1_3_TLM_HOHEITSGEBIET AS gemeinde left join '$<'.kantone as kanton on gemeinde.KANTONSNUM = kanton.KANTONSNUM" $@ downloads/$(PKG_ID)/BOUNDARIES_2020/DATEN/swissBOUNDARIES3D/SHAPEFILE_LV95_LN02/swissBOUNDARIES3D_1_3_TLM_HOHEITSGEBIET.shp -nln "gemeinde"
	# ogr2ogr -f GPKG $@ downloads/$(PKG_ID)/BOUNDARIES_2020/DATEN/swissBOUNDARIES3D/SHAPEFILE_LV95_LN02/swissBOUNDARIES3D_1_3_TLM_HOHEITSGEBIET.shp 

build/kantone.csv: downloads/$(FILE_NAME).zip
	mkdir -p $(dir $@)
	mkdir -p $(dir $<)$(PKG_ID)/
	unzip -n $< -d $(dir $<)$(PKG_ID)/
	ogr2ogr -f CSV -dialect sqlite -sql "select distinct KANTONSNUM, NAME, HERKUNFT, REVISION_J, REVISION_M from swissBOUNDARIES3D_1_3_TLM_KANTONSGEBIET ORDER BY KANTONSNUM ASC" $(dir $@)/kantone.csv $(dir $<)$(PKG_ID)/BOUNDARIES_2020/DATEN/swissBOUNDARIES3D/SHAPEFILE_LV95_LN02/swissBOUNDARIES3D_1_3_TLM_KANTONSGEBIET.shp

downloads/%.zip:
	mkdir -p $(dir $@)
	curl http://data.geo.admin.ch/ch.swisstopo.swissboundaries3d-gemeinde-flaeche.fill/data.zip -L -o $@.download
	mv $@.download $@

# clean: clean-unzip

# clean-unzip:
# 	rm -rf $(dir $<)$(PKG_ID)/

#### Datahub related

push:
	data validate
	data push