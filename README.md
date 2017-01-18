USDA Food Database
==================

This repository creates an sqlite3 file from the USDA food database, release 28,
which was published September 2015.

`make` will generate `usda.db`.  Running `make with-prices` will also generate
it with price data from cnpp.usda.gov for 2003-2004.

After downloading the data files (sr28asc.zip and FoodPricesDatabase0304.XLS)
the Makefile will attempt to verify their integrity with the `shasum` command.

