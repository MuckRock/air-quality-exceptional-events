# build, run and deploy a datasette instance

DB=airquality.db
LOOKUP_DATA=data/processed/for_datasette.csv

# shortcut
SU=poetry run sqlite-utils

# workflow

install:
	poetry install

update:

build:

run:
	poetry run datasette serve .

publish:

# data

$(DB):
	$(SU) create-database $@ --enable-wal

samples: $(DB) $(LOOKUP_DATA)
	$(SU) insert $(DB) $@ $(LOOKUP_DATA) --csv --detect-types --truncate
	$(SU) convert $(DB) $@ event_begin_date 'r.parsedate(value, errors=r.IGNORE)'
	$(SU) convert $(DB) $@ event_end_date 'r.parsedate(value, errors=r.IGNORE)'
	$(SU) convert $(DB) $@ sample_date_time 'r.parsedate(value, errors=r.IGNORE)'
	$(SU) convert $(DB) $@ concurrence_date 'r.parsedate(value, errors=r.IGNORE)'
	$(SU) convert $(DB) $@ date 'r.parsedate(value, errors=r.IGNORE)'
	$(SU) transform $(DB) $@ --type state_county_fips text
	$(SU) convert $(DB) $@ state_county_fips 'f"{int(value):05d}"'

indexes:
	# index likely facets
	$(SU) create-index $(DB) samples event_begin_date --if-not-exists
	$(SU) create-index $(DB) samples event_end_date --if-not-exists
	$(SU) create-index $(DB) samples exceptional_event_id --if-not-exists
	$(SU) create-index $(DB) samples pollutant_name --if-not-exists
	$(SU) create-index $(DB) samples event_type_code --if-not-exists
	$(SU) create-index $(DB) samples event_type_description --if-not-exists
	$(SU) create-index $(DB) samples concurrence_ind --if-not-exists
	$(SU) create-index $(DB) samples state_county_fips --if-not-exists
	$(SU) create-index $(DB) samples state_name --if-not-exists
	$(SU) create-index $(DB) samples county_name --if-not-exists

views:
	$(SU) create-view $(DB) concurred "select * from samples where concurrence_ind = 'Y'"
	$(SU) create-view $(DB) denied "select * from samples where concurrence_ind = 'N'"

clean:
	rm -f $(DB) $(DB)-shm $(DB)-wal
