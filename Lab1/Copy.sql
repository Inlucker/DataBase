copy public.Players(nickname, first_name, second_name, country, age, main_role, rating) from '/players.csv' delimiter '|' csv;

copy public.Teams(name, country, sponsor, avg_rating) from '/teams.csv' delimiter '|' csv;

copy public.PlayersTeams(player_id, team_id, cur_role) from '/PlayersTeams.csv' delimiter '|' csv;

copy public.Commentators(nickname, first_name, second_name, country, age, popularity) from '/Commentators.csv' delimiter '|' csv;

copy public.Matches(team1_id, team2_id, winner_id, commentator_id, tournament_name, date, popularity) from '/Matches.csv' delimiter '|' csv;

delete from public.Players;
delete from public.Teams;
delete from public.PlayersTeams;
delete from public.Commentators;
delete from public.Matches;