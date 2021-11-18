--1) Скалярную функцию

-- минимальный возраст среди игроков

create OR REPLACE function minAge()
returns int
as $$
begin
    return (select min(age) from players);
end;
$$ LANGUAGE 'plpgsql';

drop function  minAge();

select minAge();

--2) Подставляемую табличную функцию

-- комментаторы по возрасту

create OR REPLACE function getCommentatorsByAge(int)
returns setof commentators
as $$
begin
    return query(
        select *
        from commentators c
        where c.age = $1);
end $$ language 'plpgsql';

drop function getCommentatorsByAge(int);

select * from getCommentatorsByAge(18);

--?
create OR REPLACE function getPlayersByAge(int)
returns table 
(
	player_id int,
	nickname text,
	first_name text,
	second_name text,
	country text,
	age int,
	main_role text,
	rating int
)
as $$
begin
    return query(
        select *
        from players p
        where p.age = $1);
end $$ language 'plpgsql';

drop function getPlayersByAge(int);

select * from getPlayersByAge(18);

--3) Многооператорную табличную функцию
-- самые молодые игроки
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

select * from YoungPlayers();

--4) Рекурсивную функцию или функцию с рекурсивным ОТ

--Все игроки с age <= параметр

create OR REPLACE function Rec(int)
returns setof players
as $$
begin
	if $1 > 9 then
		return query select * from Rec($1-1);
	end if;
	return query select * from getPlayersByAge($1);
end $$ language 'plpgsql';

drop function Rec(int);

select * from Rec(18);

--1) Хранимую процедуру без параметров или с параметрами

create OR REPLACE procedure updateAvgRating(t_id int)
as $$
BEGIN
	update teams
	set avg_rating = (select avg(rating)
					  from players p join playersteams pt
					  on p.player_id = pt.player_id and team_id = t_id) - 1
	where team_id = t_id;
end
$$ language plpgsql;

drop procedure updateAvgRating(int);

call updateAvgRating(999);

--2) Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ

create OR REPLACE procedure updatePlayersRating(p_id int, new_rating int)
as $$
begin
	update players 
	set rating = new_rating
	where player_id = p_id;
	if (p_id < 1000) then
		call updatePlayersRating(p_id + 1, new_rating);
	end if;
end
$$ language plpgsql;

drop procedure updatePlayersRating(int, int);

call updatePlayersRating(998, 7777);

--3) Хранимую процедуру с курсором

create OR REPLACE procedure updateTeamsAvgRating()
as $$
declare 
	cur cursor for select team_id from teams;
	tmp int;
begin
	open cur;
	loop
		fetch cur into tmp;
		call updateAvgRating(tmp);
		exit when not found;
	end loop;
	close cur;
end
$$ language plpgsql;

drop procedure updateTeamsAvgRating();

call updateTeamsAvgRating();

--4) Хранимую процедуру доступа к метаданным
create OR REPLACE procedure getUpdateProcsNumber()
as $$
begin
	RAISE notice 'Procs number starting like update = %', (select count(oid) from
															(
																SELECT * from pg_catalog.pg_proc pp
																where proname like 'update%'
															) as cpp);
end
$$ language plpgsql;

drop procedure getUpdateProcsNumber();

call getUpdateProcsNumber();

--1) Триггер AFTER
-- Создаём функцию для триггера...
create or replace function updateTeamAvgRating()
returns trigger 
as $$
begin 
	update teams
	set avg_rating = (select avg(rating)
					  from players p join playersteams pt
					  on p.player_id = pt.player_id and team_id = new.team_id)+1
	where team_id = new.team_id;
	return new;
end
$$ language plpgsql;

drop function  updateTeamAvgRating();

--Теперь триггер
create or replace trigger tr_AvgRatingUpdate
after insert
on playersteams
for each row
execute procedure updateTeamAvgRating();

DROP trigger tr_AvgRatingUpdate on playersteams

--insert для триггера
insert into playersteams (player_id, cur_role, team_id)
select (select player_id
		from players
		where rating = (select max(rating)
						from players
						where main_role = 'OffLaner')),
		'OffLaner', 1
		
delete from playersteams
where player_id = 840 and team_id = 1

--update для сравнения
call updateTeamsAvgRating();

--2) Триггер INSTEAD OF
--Создадим view...
create or replace view v_players as
	select *
	from players p 
	where player_id > 500
	
select * from v_players

drop view v_players

-- Создаём функцию для триггера...
create or replace function MyUpdate()
returns trigger 
as $$
begin 
	update players
	set rating = (select max(rating) from players where nickname = 'Inlucker') + 1
	where nickname = 'Inlucker';
	RAISE notice 'MyUpdate is done :P';
	return new;
end
$$ language plpgsql;

drop function MyUpdate();

--Теперь триггер
create or replace trigger tr_insertPlayer
instead of update
on v_players
for each row
execute procedure MyUpdate();

DROP trigger tr_insertPlayer on v_players

--update и insert для триггера
update v_players
set rating = 6500
where nickname = 'Inlucker'

insert into v_players (nickname, first_name, second_name, country, age, main_role, rating)
					 values('Inlucker', 'Arseny', 'Pronin', 'Russian Federation', 18, 'OffLaner', 7000);

insert into players (nickname, first_name, second_name, country, age, main_role, rating)
					 values('Inlucker', 'Arseny', 'Pronin', 'Russian Federation', 18, 'OffLaner', 7000);
					
delete from players
where nickname = 'Inlucker'

--защита
create OR REPLACE function getPLayerByRating(int)
returns setof players
as $$
begin
    return query(
        select *
        from players p
        where p.rating = $1);
end $$ language 'plpgsql';

drop function getPLayerByRating(int);

select * from getPLayerByRating(7777)

