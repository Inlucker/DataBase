--1
--Все игроки из Португалии
SELECT DISTINCT P.country, P.nickname
FROM public.players AS P
WHERE P.Country = 'Portugal'
ORDER BY P.country, P.nickname

--2
--Все матчи прошедшие в мае
SELECT DISTINCT tournament_name, date
FROM matches
WHERE date BETWEEN '2021-05-01' AND '2021-05-31'
ORDER BY date

--3
--Все игроки с именем, начинающимся на  'lo'
select distinct nickname
from players
where nickname like 'lo%'
ORDER BY nickname

--4
--Найти все матчи со средним рейтингом команды победителя > 5000, c конкретным комментатором (12)
select *
from matches
where winner_id in (select team_id
					from teams
					where avg_rating > 5000)
		and commentator_id = 12
		
--5
--Выбор всех команд, которые выиграли хотябы 1 раз
select team_id, name
from teams t
where exists (select team_id
			  from matches m
			  where t.team_id = m.winner_id)
			  
--6
--Выбор игроков чей рейтинг больше чем у всех Афганистанцев
select nickname, rating
from players
where rating > all (select rating
					from players
					where country = 'Afghanistan')
					
--7
--подсчёт среднего рейтинга игроков из Португалии
select avg(rating) as actual_avg,
	   sum(rating)/count(player_id) as calc_avg
from players
where country = 'Portugal'

--8
--В скольких командах состоят игркои с рейтингом > 3500
select p.player_id, nickname,
		(select count(*)
		 from playersteams as pt
		 where p.player_id = pt.player_id)
from players p
where rating > 3500

--9
--Разделение на Русских и инопришеленцев :)
select nickname,
	case country
		when 'Russian Federation' then 'Russian'
		else 'Alien'
	end as nation
from commentators

--10
--Разделение на уровень скилла игрока судя по рейтингу
select nickname,
	case
		when rating <= 2000 then 'lowskill'
		when rating <= 4500 then 'avgskill'
		when rating <= 7000 then 'highskill'
		else 'godskill'
	end as skill
from players

--11
--создание таблицы кол-ва игрков в каждой команде
select t.team_id, t.name, count(pt.player_id) as player_count
into team_players_count
from teams t join playersteams pt on t.team_id = pt.team_id
group by t.team_id
order by t.team_id

drop table public.team_players_count cascade;


--выбор кол-ва матчей в которых поучаствовал комментатор
select c.commentator_id, c.nickname, count(mc.commentator_id) as matches_count
from commentators c join (select m.commentator_id
						 from matches m) as mc on c.commentator_id = mc.commentator_id
group by c.commentator_id
order by matches_count desc

--12
--выбор игроков, которые состоят в командах из Афганистана
select p.player_id, p.nickname, p.rating
from players p join (select player_id, team_id
				   from playersteams
				   where team_id in (select team_id
				   					 from teams t
				   					 where country = 'Afghanistan')) as af_teams on p.player_id = af_teams.player_id
group by p.player_id, af_teams.player_id, af_teams.team_id

--13
--выбор матчей с игроками первой команды, имеющими > 7500 рейтинга
select *
from matches
where team1_id IN (select distinct team_id
				  from playersteams
				  where player_id IN (select player_id
				  					 from players
				  					 where rating > 7500
				  					)
				 )
order by date

--14
--создание таблицы стран и кол-ва комментаторов в ней
select c.country, count(c.commentator_id) as commentators_count
from commentators c
group by c.country
order by c.country

--15
--создание таблицы стран с кол-вом комментаторов > 5 и кол-ва комментаторов в ней
select c.country, count(c.commentator_id) as commentators_count
from commentators c
group by c.country
having count(c.commentator_id) > 5
order by commentators_count
				 
--16
--Добавление игрока в таблицу игроков
insert into players (nickname, first_name, second_name, country, age, main_role, rating)
					 values('Inlucker', 'Arseny', 'Pronin', 'Russian Federation', 18, 'OffLaner', 7000);

delete from players where nickname = 'Inlucker'

--17
insert into playersteams (player_id, team_id, cur_role)
select p.player_id, t.team_id, p.main_role 
from players p join teams t
on p.rating >=7900 and p.main_role = 'OffLaner' and team_id = 1

insert into playersteams (player_id, cur_role, team_id)
select (select player_id
		from players
		where rating = (select max(rating)
						from players
						where main_role = 'OffLaner')),
		'OffLaner', 1

--Добавление игроков из России с рейтингом > 4000 в Российскую команду с наибольшим id
insert into playersteams (team_id, player_id, cur_role)
select (select max(team_id)
		from teams
		where country = 'Russian Federation'), p.player_id, p.main_role 
from players p 
where p.country = 'Russian Federation' and p.rating > 4000

--18
--Обновление названия для Российской команды с наибольшим id
update teams
set name = 'Virtus Pro'
where team_id = (select max(team_id)
				 from teams
				 where country = 'Russian Federation')
				 
--19
--Обновление среднего знаения рейтинга для Российской команды с наибольшим id
update teams
set avg_rating = (select avg(rating)
				  from players p join playersteams pt
				  on p.player_id = pt.player_id and team_id = (select max(team_id)
															   from teams
															   where country = 'Russian Federation'))
where team_id = (select max(team_id)
				 from teams
				 where country = 'Russian Federation')
				 
select *
from players p join playersteams pt
on p.player_id = pt.player_id and team_id = 996

--Получить таблицу ников игрков и соответсвующих им имён команд
select distinct p.player_id, nickname as player_nickname, t.team_id, t.name as team_name
from players p join playersteams pt on p.player_id = pt.player_id join teams t on t.team_id = pt.team_id 
order by p.player_id, t.team_id

--inner join 
select player_id, p.nickname as player_nickname, p.country, commentator_id, c.nickname as commentator_nickname, c.country
from players p inner join commentators c on p.country = c.country

--left join 
select player_id, p.nickname as player_nickname, p.country, commentator_id, c.nickname as commentator_nickname, c.country
from players p left join commentators c on p.country = c.country

--left outer join 
select player_id, p.nickname as player_nickname, p.country, commentator_id, c.nickname as commentator_nickname, c.country
from players p left outer join commentators c on p.country = c.country
where c.nickname is null

--right join
select player_id, p.nickname as player_nickname, p.country, commentator_id, c.nickname as commentator_nickname, c.country
from players p right join commentators c on p.country = c.country

--right outer join 
select player_id, p.nickname as player_nickname, p.country, commentator_id, c.nickname as commentator_nickname, c.country
from players p right outer join commentators c on p.country = c.country
where p.nickname is null

select player_id, p.nickname as player_nickname, p.country
from players p
where country = 'Angola' or country = 'Niger'