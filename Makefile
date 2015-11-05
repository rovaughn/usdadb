
all: usda.db

sr28asc.zip:
	wget "https://www.ars.usda.gov/SP2UserFiles/Place/12354500/Data/SR/SR28/dnload/sr28asc.zip"

data: sr28asc.zip
	mkdir -p data
	unzip sr28asc.zip -d data

usda.db: schema.sql data
	rm -f usda.db
	sqlite3 usda.db <schema.sql
	python3 import.py

usda.db.xz: usda.db
	xz -9k usda.db

clean:
	rm -f sr28asc.zip
	rm -rf data
	rm -f usda.db

