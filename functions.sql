CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

CREATE OR REPLACE FUNCTION name2id(text) RETURNS int AS 'select card_id from cards where card_name = $1' LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT ;

CREATE OR REPLACE FUNCTION id2name(int) RETURNS text AS 'select card_name from cards where card_id = $1' LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT ;

CREATE OR REPLACE FUNCTION regex2id(text) RETURNS SETOF int AS 'select card_id from cards where card_name ~* $1' LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT ;

CREATE OR REPLACE FUNCTION pair_count(
    idA int,
    idB int
) RETURNS integer AS $$
DECLARE
    ret integer;
BEGIN
 IF idA > idB THEN
    return pair_count(idB, idA);
 END IF;
 IF idA = idB THEN
   SELECT INTO ret count from card_count where card_id=idA;
 ELSE 
   SELECT INTO ret count from pair_count where a=idA and b=idB; 

   IF ret IS NULL THEN
       SELECT INTO ret count(cube_id) FROM cube_card a JOIN cube_card b USING (cube_id) WHERE a.card_id=idA AND b.card_id=idB;
       INSERT INTO pair_count (a, b, count) VALUES (idA, idB, ret);
   END IF;
 END IF;
 return ret;
END;
$$ LANGUAGE plpgsql
RETURNS NULL ON NULL INPUT;

CREATE FUNCTION count_estimate(query text) RETURNS integer AS $$
DECLARE
  rec   record;
  rows  integer;
BEGIN
  FOR rec IN EXECUTE 'EXPLAIN ' || query LOOP
    rows := substring(rec."QUERY PLAN" FROM ' rows=([[:digit:]]+)');
    EXIT WHEN rows IS NOT NULL;
  END LOOP;
  RETURN rows;
END;
$$ LANGUAGE plpgsql VOLATILE STRICT;
