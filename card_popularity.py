#!/usr/bin/env python3

import json
import psycopg2
import sys
from math import log10
from utils import *
ignore_pipe()

conn = psycopg2.connect('dbname=cube')
cur = conn.cursor()

my_cards=json.load(sys.stdin)

my_cards_ids=sorted(map(int, my_cards.keys()))

query="SELECT cc.card_id, count(cc.cube_id) FROM cube_card cc  WHERE cc.card_id IN (%s) group by 1 order by 2 desc " % (','.join(map(str,my_cards_ids)),)


cur.execute(query)
res=cur.fetchall()
score=dict(res)

cur.execute("select count(*) from cubes")
total_cubes=cur.fetchall()[0][0]

base_score=res[0][1]
scale=int(log10(base_score))+1
score_format='%%%dd' % scale
score_format='%6.2f%%\t'+score_format+'\t%s'

for card_id,s in res:
    print(score_format % (100.0*s/total_cubes,s,my_cards[str(card_id)]))
