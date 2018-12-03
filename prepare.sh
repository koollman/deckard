#!/bin/sh

DB=cube
PSQL="psql -d $DB"

set -x
$PSQL -f cube.sql
./json2pg.py | $PSQL
$PSQL -f post_load.sql
$PSQL -f cut.sql
