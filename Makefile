.PHONY: all clean

all: usda.db

with-prices: usda.db FoodPricesDatabase0304.XLS
	python3 add_prices.py

FoodPricesDatabase0304.XLS:
	wget 'https://www.cnpp.usda.gov/sites/default/files/usda_food_plans_cost_of_food/FoodPricesDatabase0304.XLS'

sr28asc.zip:
	wget "https://www.ars.usda.gov/SP2UserFiles/Place/12354500/Data/SR/SR28/dnload/sr28asc.zip"

data: sr28asc.zip
	rm -rf data
	mkdir data
	unzip sr28asc.zip -d data

usda.db: schema.sql index.sql data
	rm -f usda.db
	sqlite3 usda.db <schema.sql
	python3 import.py
	sqlite3 usda.db <index.sql

usda.db.xz: usda.db
	xz -9k usda.db

clean:
	rm -f sr28asc.zip
	rm -rf data
	rm -f usda.db

