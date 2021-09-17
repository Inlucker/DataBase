alter table public.Players ADD constraint nickname_check check (nickname is not null);
alter table public.Players ADD constraint age_check check (age>=9 and age <= 100);
alter table public.Players ADD constraint main_role_check
			check (main_role IN ('SafeLaner', 'MidLaner', 'OffLaner', 'SoftSupport', 'HardSupport'));
alter table public.Players ADD constraint rating_check check (rating > 0);
				  

alter table public.Teams ADD constraint name_check check (name is not null);				  
alter table public.Teams ADD constraint avg_rating_check check (avg_rating > 0);


alter table public.PlayersTeams ADD constraint cur_role_check
			check (cur_role IN ('SafeLaner', 'MidLaner', 'OffLaner', 'SoftSupport', 'HardSupport'));
			
		
alter table public.Commentators ADD constraint nickname_check check (nickname is not null);
alter table public.Commentators ADD constraint age_check check (age>=9 and age <= 100);


alter table public.Matches ADD constraint team1_id_check check (team1_id is not null);
alter table public.Matches ADD constraint team2_id_check check (team2_id is not null);
alter table public.Matches ADD constraint commentator_id_check check (commentator_id is not null);
alter table public.Matches ADD constraint tournament_name_check check (tournament_name is not null);



insert into public.Players values(0, 'Inlucker', 'Arseny', 'Pronin', 'Russia', 18, 'OffLaner', 7000);

				  
insert into public.Teams(team_id) values(0);
insert into public.Teams(team_id) values(1);


insert into public.Commentators(commentator_id) values(0);

insert into public.Matches(team1_id, team2_id, winner_id, commentator_id)
			values(0, 1, null, 0);

		

delete from public.Players;
delete from public.Teams;
delete from public.PlayersTeams;
delete from public.Commentators;
delete from public.Matches;