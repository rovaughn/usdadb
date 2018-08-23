.PHONY: all clean with-prices

all: usda.db

with-prices: usda.db FoodPricesDatabase0304.XLS
	python3 add_prices.py

FoodPricesDatabase0304.XLS:
	wget 'https://www.cnpp.usda.gov/sites/default/files/usda_food_plans_cost_of_food/FoodPricesDatabase0304.XLS'
	shasum -a 512224 -c prices.shasum

usda-data.zip:
	wget -O "$@" "https://www.ars.usda.gov/ARSUserFiles/80400525/Data/SR-Legacy/SR-Leg_ASC.zip"
	shasum -a 512224 -c usda-data.shasum

usda-data: usda-data.zip
	rm -rf usda-data
	mkdir usda-data
	unzip usda-data.zip -d usda-data

usda.db: schema.sql usda-data
	rm -f usda.db
	sqlite3 usda.db <schema.sql
	python3 import.py

usda.db.xz: usda.db
	xz -k usda.db

clean:
	rm -rf usda-data
	rm -f usda.db

clean-all: clean
	rm -f usda-data.zip
