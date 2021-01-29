CKAN_Endpoint = "https://opendata.swiss/api/3/"
# action/package_show?id=
PKG_ID = swissboundaries3d_gemeindegrenzen
FILE_NAME = swissBOUNDARIES3D
GMD = gemeinden-collected.gpkg

.PHONY: all

all: data/gemeinden.json clean

data/gemeinden.json: data/gemeinden.csv
	mkdir -p $(dir $@)
	cat $< | node_modules/.bin/csvtojson > $@

data/gemeinden.csv: data/gemeinden.geojson
	mkdir -p $(dir $@)
	ogr2ogr -lco STRING_QUOTING=IF_NEEDED -f CSV $@ $<

data/gemeinden.geojson: build/gemeinden-clean.gpkg
	mkdir -p $(dir $@)
	ogr2ogr -f GeoJSON -t_srs "EPSG:4326" $@ $<
	sed -i '' 's/ [(][A-Z][A-Z][)]//g' $@

build/gemeinden-clean.gpkg: build/gemeinden-collected.gpkg
	mkdir -p $(dir $@)
	ogr2ogr -f GPKG $@ $< -sql 'select distinct `gemeinde.BFS_NUMMER`,`gemeinde.NAME`,`kanton.KUERZEL`,`kanton.NAME`, geom from gemeinde WHERE `gemeinde.BFS_NUMMER` < 9000 OR `gemeinde.BFS_NUMMER` > 9999 ORDER BY `gemeinde.BFS_NUMMER` ASC'

build/gemeinden.gpkg: src/kantone.csv build/kantone.csv
	ogr2ogr -f GPKG -sql "select gemeinde.*, kanton.* from swissBOUNDARIES3D_1_3_TLM_HOHEITSGEBIET AS gemeinde left join '$<'.kantone as kanton on gemeinde.KANTONSNUM = kanton.KANTONSNUM WHERE gemeinde.ICC = 'CH'" $@ downloads/$(PKG_ID)/swissBOUNDARIES3D_1_3_TLM_HOHEITSGEBIET.shp -nln "gemeinde"
	# ogr2ogr -f GPKG $@ downloads/$(PKG_ID)/BOUNDARIES_2020/DATEN/swissBOUNDARIES3D/SHAPEFILE_LV95_LN02/swissBOUNDARIES3D_1_3_TLM_HOHEITSGEBIET.shp 

build/kantone.csv: downloads/$(FILE_NAME).zip
	mkdir -p $(dir $@)
	mkdir -p $(dir $<)$(PKG_ID)/
	unzip -n $< -d $(dir $<)$(PKG_ID)/
	ogr2ogr -f CSV -dialect sqlite -sql "select distinct KANTONSNUM, NAME, HERKUNFT, REVISION_J, REVISION_M from swissBOUNDARIES3D_1_3_TLM_KANTONSGEBIET ORDER BY KANTONSNUM ASC" $(dir $@)/kantone.csv $(dir $<)$(PKG_ID)/swissBOUNDARIES3D_1_3_TLM_KANTONSGEBIET.shp

downloads/%.zip:
	mkdir -p $(dir $@)
	cd downloads
	curl https://data.geo.admin.ch/ch.swisstopo.swissboundaries3d-gemeinde-flaeche.fill/shp/2056/ch.swisstopo.swissboundaries3d-gemeinde-flaeche.fill.zip -L -o $@.download
	# curl http://data.geo.admin.ch/ch.swisstopo.swissboundaries3d-gemeinde-flaeche.fill/data.zip -L -o $@.download
	mv $@.download $@

clean:
	rm -rf build/
	rm -rf downloads/$(PKG_ID)/
	rm data/gemeinden.csv.bkp

# clean-unzip:
#  	rm -rf downloads/$(PKG_ID)/

clean-data:
	rm -rf data/

#### Datahub related

datahub: validate push

validate:
	./node_modules/.bin/data validate

push:
	./node_modules/.bin/data push
