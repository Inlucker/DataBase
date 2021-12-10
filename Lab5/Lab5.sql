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
CREATE TABLE tmp_json
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