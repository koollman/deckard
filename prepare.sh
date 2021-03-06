#!/bin/sh

DB=cube
PSQL="psql -d $DB"

set -x
$PSQL -f cube.sql
$PSQL -f functions.sql
$PSQL -f views.sql
./json2pg.py | $PSQL
$PSQL -f post_load.sql
$PSQL -f cut.sql
$PSQL -f end.sql
