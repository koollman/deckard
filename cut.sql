-- remove low occurence cards
DELETE FROM cards WHERE card_id IN (
       SELECT card_id FROM cube_card NATURAL JOIN cards GROUP BY 1 HAVING count(cube_id) < 100
);

-- remove too small/large cubes
DELETE FROM cubes WHERE cube_id IN (
       SELECT cube_id FROM cube_card GROUP BY cube_id HAVING count(card_id) > 720 OR count(card_id) < 180
);

cluster;
analyze;

