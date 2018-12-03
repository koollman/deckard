#!/usr/bin/env python3

import json

db=json.load(open('db.json'))

for table in ('cube_card', 'cards', 'cubes'):
    print('TRUNCATE', table, ';')

print('copy cards (card_id, card_name) FROM STDIN;')
for name, card in db['cards'].items():
    print('%s\t%s' % (card, name) )
print('\.')

print('copy cubes (cube_id) FROM STDIN;')
for cube in db['cubes'].keys():
    print(cube)
print('\.')

print('copy cube_card (cube_id,card_id) FROM STDIN;')
for cube,cards in db['cubes'].items():
    for card in cards:
        print('%s\t%s' % (cube,card))
print('\.')
