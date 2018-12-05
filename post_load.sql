ALTER TABLE cards ADD PRIMARY KEY (card_id);
ALTER TABLE cubes ADD PRIMARY KEY (cube_id);
ALTER TABLE cube_card ADD PRIMARY KEY (cube_id,card_id);

-- CREATE UNIQUE index cards_card_id_idx ON cards(card_id);
CREATE UNIQUE index cards_card_name_idx ON cards(card_name);
-- CREATE UNIQUE index cubes_cube_id_idx ON cubes(cube_id);

CREATE index cube_card_card_id_idx ON cube_card(card_id);
CREATE index cube_card_cube_id_idx ON cube_card(cube_id);

ALTER TABLE cards CLUSTER ON cards_pkey ;
ALTER TABLE cubes CLUSTER ON cubes_pkey ;
ALTER TABLE cube_card CLUSTER on cube_card_card_id_idx;

ALTER TABLE cube_card ADD CONSTRAINT cube_card_cube_id_fkey FOREIGN KEY (cube_id) REFERENCES cubes(cube_id) ON DELETE CASCADE ON UPDATE CASCADE ;
ALTER TABLE cube_card ADD CONSTRAINT cube_card_card_id_fkey FOREIGN KEY (card_id) REFERENCES cards(card_id) ON DELETE CASCADE ON UPDATE CASCADE ;

CREATE STATISTICS cube_card_stat ON cube_id, card_id FROM cube_card;
CREATE STATISTICS cards_stat ON card_id, card_name FROM cards;


ALTER TABLE cube_card ALTER card_id SET STATISTICS 10000 ;
ALTER TABLE cube_card ALTER cube_id SET STATISTICS 10000 ;

analyze;
