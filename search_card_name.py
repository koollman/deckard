#!/usr/bin/env python3

import psycopg2
import sys
import json
from utils import *

ignore_pipe()

conn = psycopg2.connect('dbname=cube')
cur = conn.cursor()

names=sys.argv[1:]

query="SELECT card_id, card_name from cards where card_name ~* %s"
results={}
for name in names:
    cur.execute(query, (name,))
    result=cur.fetchall()
    if not result:
        eprint("WARN: nothing found for '%s'" % name)
    if len(result)>1:
        allnames=[n for (i,n) in result]
        eprint("WARN: %d results for '%s': %s" % (len(result), name, allnames))
    results.update(result)

json.dump(results, sys.stdout)
print()
