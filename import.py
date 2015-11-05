import sqlite3
import sys

# For some reason the files are encoded in some unknown format.  I compared the
# text files against what I got by searching the USDA website and made this
# conversion table.
encoding_patches = {
    0x91: '\u8216', # left curly single quote
    0x92: '\u8217', # right curly single quote
    0x94: '"',
    0xa0: ' ',
    0xa9: ' ',
    0xe9: '\u00e9', # e with acute
    0xb5: '\u039c', # mu
}

def decode(line):
    return ''.join(encoding_patches.get(b, chr(b)) for b in line)

# A row in the text files is a sequence of fields separated by '^'.  A field can
# be wrapped in '~'.  For instance:
#
# ~01009~^~0100~^~Cheese, cheddar~^~CHEESE,CHEDDAR~^~~^~~^~Y~^~~^0^~~^^^^
#
# The ~ seem to distinguish strings from numbers, but we'll treat them all as
# strings, since it won't matter when they get inserted into the sqlite
# database.
def parse_row(row):
    row = decode(row).rstrip()

    i = 0

    while True:
        if len(row) > i and row[i] == '~':
            end = row.index('~', i+1)
            yield row[i+1:end]
            i = end + 1
        else:
            try:
                end = row.index('^', i)
            except ValueError:
                end = len(row)
            yield row[i:end]
            i = end

        if len(row) == i:
            return
        elif row[i] == '^':
            i += 1
        else:
            raise Exception('Expected ^ or eol at col %d' % (i + 1))

db = sqlite3.connect('usda.db')
c = db.cursor()

def process_row(fields, row):
    for (name, func), cell in zip(fields, row):
        if func is None:
            yield cell
        else:
            yield func(cell)

def import_table(filename, table, fields):
    filepath = 'data/%s.txt' % filename
    print('Importing %r into %r...' % (filepath, table))

    with open(filepath, 'rb') as f:
        for line in f:
            row = tuple(process_row(fields, parse_row(line)))

            try:
                c.execute(
                    'insert into %s (%s) values (%s)' % (
                        table,
                        ', '.join(name for name, _ in fields),
                        ', '.join(['?'] * len(fields))
                    ),
                    row
                )
            except Exception as e:
                print('Could not insert row %r into table %r' % (row, table))
                print(e)
                sys.exit(1)

def boolify(cell):
    return cell == 'Y'

def nullify(cell):
    return None if cell == '' else cell

def nullify0(cell):
    return None if cell in ('', 0) else cell

def date(text):
    try:
        if text == '':
            return None

        month, year = text.split('/')

        return '%04s-%02s-%02s' % (year, month, '00')
    except Exception as e:
        raise Exception('date: %r: %s' % (text, e))

import_table('DATA_SRC', 'data_source', (
    ('id', None),
    ('authors', nullify),
    ('title', None),
    ('year', nullify),
    ('journal', nullify),
    ('volume_city', nullify),
    ('issue_state', nullify),
    ('start_page', nullify),
    ('end_page', nullify),
))

import_table('FOOTNOTE', 'footnote', (
    ('food', None),
    ('no', None),
    ('type', None),
    ('nutrient', nullify),
    ('description', None),
))

import_table('FOOD_DES', 'food', (
    ('id', None),
    ('food_group', None),
    ('long_description', None),
    ('short_description', None),
    ('common_name', nullify),
    ('manufacturer', nullify),
    ('survey', boolify),
    ('refuse_description', nullify),
    ('refuse_percentage', nullify),
    ('scientific_name', nullify),
    ('nitrogen_factor', nullify),
    ('protein_factor', nullify),
    ('fat_factor', nullify),
    ('cho_factor', nullify)
))

import_table('FD_GROUP', 'food_group', (
    ('id', None),
    ('description', None),
))

import_table('LANGUAL', 'food_langual_factor', (
    ('food', None),
    ('factor', None),
))

import_table('LANGDESC', 'langual_factor', (
    ('id', None),
    ('description', None),
))

import_table('NUT_DATA', 'food_nutrient', (
    ('food', None),
    ('nutrient', None),
    ('amount_100g', None),
    ('data_points', nullify0),
    ('std_error', nullify),
    ('source', None),
    ('derivation', nullify),
    ('reference_food', nullify),
    ('nutrients_added', boolify),
    ('studies', nullify),
    ('min', nullify),
    ('max', nullify),
    ('degrees_freedom', nullify),
    ('lower_error_95', nullify),
    ('upper_error_95', nullify),
    ('statistical_note', nullify),
    ('updated', date),
))

import_table('NUTR_DEF', 'nutrient', (
    ('id', None),
    ('units', None),
    ('tagname', nullify),
    ('description', None),
    ('decimal_places', None),
    ('sort_order', None)
))

import_table('SRC_CD', 'source', (
    ('id', None),
    ('description', None),
))

import_table('DERIV_CD', 'derivation', (
    ('id', None),
    ('description', None),
))

import_table('WEIGHT', 'weight', (
    ('food', None),
    ('sequence', None),
    ('amount', None),
    ('measurement', None),
    ('gram_weight', None),
    ('data_points', nullify),
    ('std_dev', nullify),
))

import_table('DATSRCLN', 'food_nutrient_source', (
    ('food', None),
    ('nutrient', None),
    ('data_source', None),
))

db.commit()
db.close()

