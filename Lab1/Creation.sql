create table public.Players
(
	player_id int primary key,
	nickname text,
	first_name text,
	second_name text,
	country text,
	age int,
	main_role text,
	rating int
);

create table public.Teams
(
	team_id int primary key,
	name text,
	country text,
	sponsor text,
	avg_rating int
);

create table public.PlayersTeams
(
	player_id int,
	team_id int,
	FOREIGN KEY (player_id) REFERENCES public.Players (player_id),
	FOREIGN KEY (team_id) REFERENCES public.Teams (team_id),
	cur_role text
);

create table public.Commentators
(
	commentator_id int primary key,
	nickname text,
	first_name text,
	second_name text,
	country text
);

create table public.Matches
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
	date text
);

drop table public.Players cascade;
drop table public.Teams cascade;
drop table public.PlayersTeams cascade;
drop table public.Commentators cascade;
drop table public.Matches cascade;