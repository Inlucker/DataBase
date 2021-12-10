--1)
select row_to_json(p) from players p;
select row_to_json(t) from teams t;
select row_to_json(pt) from playersteams pt;
select row_to_json(c) from commentators c;
select row_to_json(m) from matches m;

copy (select row_to_json(p) from players p) to '/tmp/players.json';
copy (select row_to_json(t) from teams t) to '/tmp/teams.json';
copy (select row_to_json(pt) from playersteams pt) to '/tmp/playersteams.json';
copy (select row_to_json(c) from commentators c) to '/tmp/commentators.json';
copy (select row_to_json(m) from matches m) to '/tmp/matches.json';

--2)
--clear
delete from public.Matches;
delete from public.Commentators;
delete from public.PlayersTeams;
delete from public.Teams;
delete from public.Players;

--create tmp table for json->table
DROP TABLE IF EXISTS tmp_json;
CREATE TEMP TABLE tmp_json
(
    row jsonb
);

--select * from tmp_json

--players
delete from tmp_json;
COPY tmp_json FROM '/tmp/players.json';
INSERT INTO players
SELECT (row->>'player_id')::int,
		(row->>'nickname')::text,
		(row->>'first_name')::text,
		(row->>'second_name')::text,
		(row->>'country')::text,
		(row->>'age')::int,
		(row->>'main_role')::text,
		(row->>'rating')::int FROM tmp_json;

--teams
delete from tmp_json;
COPY tmp_json FROM '/tmp/teams.json';
INSERT INTO teams
SELECT (row->>'team_id')::int,
		(row->>'name')::text,
		(row->>'country')::text,
		(row->>'sponsor')::text,
		(row->>'avg_rating')::int FROM tmp_json;
		
--playersteams
delete from tmp_json;
COPY tmp_json FROM '/tmp/playersteams.json';
INSERT INTO playersteams 
SELECT (row->>'player_id')::int,
		(row->>'team_id')::int,
		(row->>'cur_role')::text FROM tmp_json;
		
--commentators
delete from tmp_json;
COPY tmp_json FROM '/tmp/commentators.json';
INSERT INTO commentators
SELECT (row->>'commentator_id')::int,
		(row->>'nickname')::text,
		(row->>'first_name')::text,
		(row->>'second_name')::text,
		(row->>'country')::text,
		(row->>'age')::int,
		(row->>'popularity')::int FROM tmp_json;
		
--matches
delete from tmp_json;
COPY tmp_json FROM '/tmp/matches.json';
INSERT INTO matches
SELECT (row->>'team1_id')::int,
		(row->>'team2_id')::int,
		(row->>'winner_id')::int,
		(row->>'commentator_id')::int,
		(row->>'tournament_name')::text,
		(row->>'date')::text,
		(row->>'popularity')::int FROM tmp_json;
		
--3)
--Creation
DROP TABLE IF EXISTS json_test;
CREATE temp TABLE json_test
(
    row jsonb
);

--Insertion
INSERT INTO json_test VALUES
('{"nickname": "Inlucker", "first_name": "Arseny", "second_name": "Pronin", "Country": "Russia", "age": 21, "main_role": "Offlaner", "rating": 6500}'),
('{"nickname": "SMOKE", "first_name": "Ivan", "second_name": "Ivanov", "Country": "Russia", "age": 18, "main_role": "DeadInside", "rating": 7000}');

select * from json_test;

--4.1)
select * from json_test
where (row->>'nickname')::text = 'Inlucker';

--4.2)
SELECT row->'nickname' nickname, row->'main_role' main_role FROM json_test;

--4.3)
CREATE OR REPLACE FUNCTION key_exists(some_json json, outer_key text)
RETURNS boolean AS $$
BEGIN
    RETURN (some_json->outer_key) IS NOT NULL;
END;
$$ LANGUAGE plpgsql;

select key_exists('{"nickname": "Inlucker", "first_name": "Arseny", "second_name": "Pronin"}'::json, 'first_name');
select key_exists('{"nickname": "Inlucker", "first_name": "Arseny", "second_name": "Pronin"}'::json, 'third_name');

--4.4)
-- ялнсй->SMOKE
update json_test
SET row = jsonb_set(row, '{nickname}', '"ялнсй"', true)
where (row->>'nickname')::text = 'SMOKE';

-- SMOKE->ялнсй
UPDATE json_test SET row = row || '{"nickname":"SMOKE"}'::jsonb where (row->>'nickname')::text = 'ялнсй';


--4.5)
select * from jsonb_array_elements
('[
	{"nickname": "Inlucker", "first_name": "Arseny", "second_name": "Pronin", "Country": "Russia", "age": 21, "main_role": "Offlaner", "rating": 6500},
	{"nickname": "SMOKE", "first_name": "Ivan", "second_name": "Ivanov", "Country": "Russia", "age": 18, "main_role": "DeadInside", "rating": 7000}
]')