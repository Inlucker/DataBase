--Все игроки с именем, начинающимся на  'lo'
select distinct nickname
from players
where nickname like 'lo%'
ORDER BY nickname;

--Выбор игроков чей рейтинг больше чем у всех Афганистанцев
select nickname, rating
from players
where rating > all (select rating
					from players
					where country = 'Afghanistan');
					
--Подсчёт среднего рейтинга игроков из Португалии
select avg(rating) as actual_avg,
	   sum(rating)/count(player_id) as calc_avg
from players
where country = 'Portugal'

--В скольких командах состоят игркои с рейтингом > 3500
select p.player_id, nickname,
		(select count(*)
		 from playersteams as pt
		 where p.player_id = pt.player_id)
from players p
where rating > 3500

--2) Подставляемую табличную функцию
-- игроки по возрасту
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