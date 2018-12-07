DROP TABLE IF EXISTS  cards,cubes,cube_card CASCADE;

CREATE TABLE cards (
	card_id int NOT NULL,
	card_name text NOT NULL
);

CREATE TABLE cubes (
	cube_id int NOT NULL
);

CREATE TABLE cube_card (
       cube_id int NOT NULL,
       card_id int NOT NULL
);

CREATE TABLE pair_count(
    a int NOT NULL,
    b int NOT NULL,
    count int NOT NULL
);
