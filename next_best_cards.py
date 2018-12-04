#!/usr/bin/env python3

import json
import psycopg2
import sys

conn = psycopg2.connect('dbname=cube')
cur = conn.cursor()

my_cards=json.load(sys.stdin)

my_cards_ids=sorted(map(int, my_cards.keys()))

sub=[]
cond=[]
for i,card_id in enumerate(my_cards_ids):
    if i == 0:
        subquery="select cc0.cube_id from cube_card cc0"
        subcond="\n WHERE\n\tcc0.card_id=%d" % card_id
    else:
        subquery="cube_card cc%d ON (cc0.cube_id=cc%d.cube_id)" % (i,i)
        subcond="cc%d.card_id=%d" % (i, card_id)
    sub.append(subquery)
    cond.append(subcond)

subquery='\n JOIN '.join(sub)+' AND\n\t'.join(cond)

query="SELECT cc.card_id, count(cc.cube_id) FROM cube_card cc JOIN (\n%s\n) sub on (sub.cube_id=cc.cube_id)\n WHERE cc.card_id NOT IN (%s) group by 1 order by 2 desc limit 50 " % (subquery,','.join(map(str,my_cards_ids)))

print(query)

cur.execute(query)
res=cur.fetchall()

if not res:
    print("no luck")
    sys.exit(0)

next_id=[i for i,c in res]
score=dict(res)

name_query="select card_id, card_name from cards where card_id in (%s)" % (','.join(map(str,next_id)),)
cur.execute(name_query)
names=dict(cur.fetchall())

for card_id in next_id:
    print(names[card_id], score[card_id])
