#!/bin/sh

DB=cube
PSQL=psql -d $DB

set -x
$DB -f cube.sql
./json2pg.py | $db
$DB -f post_load.sql
$DB -f cut.sql
