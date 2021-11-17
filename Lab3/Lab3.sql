--1) Скалярную функцию

-- минимальный возраст среди игроков

create OR REPLACE function minAge()
returns int
as $$
begin
    return (select min(age) from players);
end;
$$
LANGUAGE 'plpgsql';

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
end $$
language 'plpgsql';

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
end $$
language 'plpgsql';

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
end $$
language 'plpgsql';

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
end $$
language 'plpgsql';

drop function Rec(int);

select * from Rec(18);