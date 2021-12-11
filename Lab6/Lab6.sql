--1)
select min(age) from players;

--2)
select distinct p.player_id, nickname as player_nickname, t.team_id, t.name as team_name
from players p join playersteams pt on p.player_id = pt.player_id join teams t on t.team_id = pt.team_id 
order by p.player_id, t.team_id;

--3)
with team_players_count(team_id, team_name, players_count) as
(
    select t.team_id, t.name, count(pt.player_id) as player_count
    from teams t join playersteams pt on t.team_id = pt.team_id
    group by t.team_id
    order by t.team_id
)
select avg(players_count) as avg_players_count_in_teams
from team_players_count;

--4)
drop view v_players;

create view v_players as
select * from players;

SELECT table_schema, table_name
FROM INFORMATION_SCHEMA.tables
WHERE table_type='VIEW' AND table_schema=ANY(current_schemas(false))
ORDER BY table_name;

--5)
create OR REPLACE function minAge()
returns int
as $$
begin
    return (select min(age) from players);
end;
$$ LANGUAGE 'plpgsql';

drop function  minAge();

select minAge();

--6)
create OR REPLACE function YoungPlayers()
returns setof players
as $$
declare
    min int;
begin
	min := minAge();
	return query(select p.*
        from players p
        where p.age = min);
end $$ language 'plpgsql';

drop function YoungPlayers();

select nickname, age from YoungPlayers();

--7)
create OR REPLACE procedure updateAvgRating(t_id int)
as $$
BEGIN
	update teams
	set avg_rating = (select avg(rating)
					  from players p join playersteams pt
					  on p.player_id = pt.player_id and team_id = t_id) + 1
	where team_id = t_id;
end
$$ language plpgsql;

drop procedure updateAvgRating(int);

call updateAvgRating(999);

--8)
select current_database();

--9)
drop table tournaments cascade;

create table if not exists Tournaments
(
    tournament_id serial primary key,
    name text,
    country text,
    city text,
    prize_pool text,
    start_date date,
    end_date date
);

--10)
delete from tournaments;

insert into Tournaments (name, country, city, prize_pool, start_date, end_date)
values('The International 10', 'Romania', 'Bucharest', '$40,018,195 USD', '10-07-2021', '10-17-2021');
insert into Tournaments (name, country, city, prize_pool, start_date, end_date)
values('EPICENTER', 'Russia', 'Moscow ', '$1,000,000 USD', '06-22-2019', '06-30-2019');

--11) Def - самый попул€рный матч дл€ комментатора
select * from matches where popularity =
(select max(popularity)
from matches where commentator_id = 2)