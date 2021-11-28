create extension plpython3u;

--1) Определяемую пользователем скалярную функцию CLR

create OR REPLACE function getTeamAvgRating(team text)
returns int
as $$
    plan = plpy.prepare("SELECT * FROM teams WHERE name = $1", ["text"])
    result = plpy.execute(plan, [team])
    rez = result[0]["avg_rating"]
    return rez
$$ LANGUAGE PLPYTHON3U;

select getTeamAvgRating('Out ');

drop function  getTeamAvgRating(text);

--2) Пользовательскую агрегатную функцию CLR

create OR REPLACE function minAge2()
returns int
as $$
    return plpy.execute("select min(age) from players;")[0]["min"]
    #result = plpy.execute("select min(age) from players;")
    #rez = result[0]["min"]
    #return rez
$$ LANGUAGE PLPYTHON3U;

select minAge2();

drop function  minAge2();

--3) Определяемую пользователем табличную функцию CLR

create OR REPLACE function getCommentatorsByAge2(age int)
returns setof commentators
as $$
    plan = plpy.prepare("SELECT * from commentators c where c.age = $1", ["int"])
    result = plpy.execute(plan, [age])
    return result    
$$ language PLPYTHON3U;

select * from getCommentatorsByAge2(18);

drop function getCommentatorsByAge2(int);

--4) Хранимую процедуру CLR

create OR REPLACE procedure updateAvgRating2(t_id int)
as $$
    plan = plpy.prepare("update teams set avg_rating = \
							(select avg(rating) \
							from players p join playersteams pt \
							on p.player_id = pt.player_id and team_id = $1) - 1 \
						where team_id = $1", ["int"])
    result = plpy.execute(plan, [t_id])
$$ language PLPYTHON3U;

call updateAvgRating2(999);

drop procedure updateAvgRating2(int);

--5) Триггер CLR

-- Создаём функцию для триггера...
create or replace function updateTeamAvgRating2()
returns trigger 
as $$
	plan = plpy.prepare("update teams set avg_rating = \
							(select avg(rating) \
							from players p join playersteams pt on \
							p.player_id = pt.player_id and team_id = $1)+1 \
						where team_id = $1;", ["int"])
	result = plpy.execute(plan, [TD["new"]["team_id"]])
$$ language PLPYTHON3U;

drop function updateTeamAvgRating2();

--Теперь триггер
create or replace trigger tr_AvgRatingUpdate
after insert
on playersteams
for each row
execute procedure updateTeamAvgRating2();

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
where player_id = 840 and team_id = 1;

--update для сравнения
call updateTeamsAvgRating();

--6) Определяемый пользователем тип данных CLR
drop TYPE player_name_rating_t;
create TYPE player_name_rating_t AS (nickname text, rating int);

CREATE OR REPLACE FUNCTION make_pnr(n text, r int)
RETURNS player_name_rating_t
AS $$
    return [n, r]
$$ LANGUAGE PLPYTHON3U;

SELECT * FROM make_pnr('Inlucker', 6500);

drop function make_pnr(text, int);