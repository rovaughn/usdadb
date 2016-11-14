import sqlite3
import xlrd
import itertools

book = xlrd.open_workbook('FoodPricesDatabase0304.XLS')
sheet = book.sheet_by_name('food')

db = sqlite3.connect('usda.db')
db.isolation_level = None
c = db.cursor()

c.execute('''begin''')
c.execute('''
    create table price (
        id int primary key,
        name text,
        price2003 decimal(16, 15)
    )
''')

for i in itertools.count(2):
    try:
        row = sheet.row_values(i)
    except IndexError:
        break

    code, name, price = row
    c.execute('''
        insert into price(id, name, price2003) values (?, ?, ?)
    ''', (code, name, price))

c.execute('''commit''')

