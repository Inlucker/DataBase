drop table public.Players cascade;
drop table public.Teams cascade;
drop table public.PlayersTeams cascade;
drop table public.Commentators cascade;
drop table public.Matches cascade;

create table if not exists public.Players
(
	player_id serial primary key,
	nickname text,
	first_name text,
	second_name text,
	country text,
	age int,
	main_role text,
	rating int
);

create table if not exists public.Teams
(
	team_id serial primary key,
	name text,
	country text,
	sponsor text,
	avg_rating int
);

create table if not exists public.PlayersTeams
(
	player_id int,
	team_id int,
	FOREIGN KEY (player_id) REFERENCES public.Players (player_id),
	FOREIGN KEY (team_id) REFERENCES public.Teams (team_id),
	cur_role text
);

create table if not exists public.Commentators
(
	commentator_id serial primary key,
	nickname text,
	first_name text,
	second_name text,
	country text,
	age int,
	popularity int
);

create table if not exists public.Matches
(
	team1_id int,
	team2_id int,
	winner_id int,
	commentator_id int,
	FOREIGN KEY (team1_id) REFERENCES public.Teams (team_id),
	FOREIGN KEY (team2_id) REFERENCES public.Teams (team_id),
	FOREIGN KEY (winner_id) REFERENCES public.Teams (team_id),
	FOREIGN KEY (commentator_id) REFERENCES public.Commentators (commentator_id),
	tournament_name text,
	date text,
	popularity int
);