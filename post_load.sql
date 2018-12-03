ALTER TABLE cards ADD PRIMARY KEY (card_id);
ALTER TABLE cubes ADD PRIMARY KEY (cube_id);
ALTER TABLE cube_card ADD PRIMARY KEY (cube_id,card_id);

-- CREATE UNIQUE index cards_card_id_idx ON cards(card_id);
CREATE UNIQUE index cards_card_name_idx ON cards(card_name);
-- CREATE UNIQUE index cubes_cube_id_idx ON cubes(cube_id);

CREATE index cube_card_card_id_idx ON cube_card(card_id);
CREATE index cube_card_cube_id_idx ON cube_card(cube_id);

CLUSTER cards using cards_pkey ;
CLUSTER cubes using cubes_pkey ;
CLUSTER cube_card using cube_card_card_id_idx;
