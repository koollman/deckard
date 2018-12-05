CREATE MATERIALIZED VIEW card_count AS
SELECT card_id, count(cube_id) AS count FROM cube_card group by 1 order by 2;
CREATE unique INDEX on card_count (card_id);
CREATE INDEX on card_count (count);

