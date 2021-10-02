--1 Инструкция SELECT, использующая предикат сравнения.
--Все игроки из Португалии
SELECT DISTINCT P.country, P.nickname
FROM public.players AS P
WHERE P.Country = 'Portugal'
ORDER BY P.country, P.nickname

--2 Инструкция SELECT, использующая предикат BETWEEN.
--Все матчи прошедшие в мае
SELECT DISTINCT tournament_name, date
FROM matches
WHERE date BETWEEN '2021-05-01' AND '2021-05-31'
ORDER BY date

--3 Инструкция SELECT, использующая предикат LIKE.
--Все игроки с именем, начинающимся на  'lo'
select distinct nickname
from players
where nickname like 'lo%'
ORDER BY nickname

--4 Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
--Найти все матчи со средним рейтингом команды победителя > 5000, c конкретным комментатором (12)
select *
from matches
where winner_id in (select team_id
					from teams
					where avg_rating > 5000)
		and commentator_id = 12
		
--5 Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
--Выбор всех команд, которые выиграли хотябы 1 раз
select team_id, name
from teams t
where exists (select team_id
			  from matches m
			  where t.team_id = m.winner_id)
			  
--6 Инструкция SELECT, использующая предикат сравнения с квантором.
--Выбор игроков чей рейтинг больше чем у всех Афганистанцев
select nickname, rating
from players
where rating > all (select rating
					from players
					where country = 'Afghanistan')
					
--7 Инструкция SELECT, использующая агрегатные функции в выражениях столбцов.
--Подсчёт среднего рейтинга игроков из Португалии
select avg(rating) as actual_avg,
	   sum(rating)/count(player_id) as calc_avg
from players
where country = 'Portugal'

--8 Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
--В скольких командах состоят игркои с рейтингом > 3500
select p.player_id, nickname,
		(select count(*)
		 from playersteams as pt
		 where p.player_id = pt.player_id)
from players p
where rating > 3500

--9 Инструкция SELECT, использующая простое выражение CASE.
--Разделение на Русских и инопришеленцев :)
select nickname,
	case country
		when 'Russian Federation' then 'Russian'
		else 'Alien'
	end as nation
from commentators

--10 Инструкция SELECT, использующая поисковое выражение CASE.
--Разделение на уровень скилла игрока судя по рейтингу
select nickname,
	case
		when rating <= 2000 then 'lowskill'
		when rating <= 4500 then 'avgskill'
		when rating <= 7000 then 'highskill'
		else 'godskill'
	end as skill
from players

--11 Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT.
--Создание таблицы кол-ва игрков в каждой команде, хотябы с одним игроком
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

--12 Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM. (?)
--тест
select *
from playersteams pt
where --cur_role = 'MidLaner' and
	  player_id in (select player_id
	  				from players p
	  				where rating > 7000
	  				and pt.cur_role = 'MidLaner')

--Выбор игроков, которые состоят в командах из Афганистана
select p.player_id, p.nickname, p.rating
from players p join (select player_id, team_id
				   from playersteams pt
				   where team_id in (select team_id
				   					 from teams t
				   					 where country = 'Afghanistan')) as af_teams on p.player_id = af_teams.player_id

--Выбор игроков, которые состоят в командах из Афганистана и имеют текущую роль 'HardSupport'
select p.player_id, p.nickname, p.rating
from players p join (select player_id, team_id
				   from playersteams pt
				   where team_id in (select team_id
				   					 from teams t
				   					 where country = 'Afghanistan' and
				   					 pt.cur_role = 'HardSupport')) as af_teams on p.player_id = af_teams.player_id

--13 Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3.
--Выбор матчей с игроками первой команды, имеющими > 7500 рейтинга
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

--14 Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING.
--Создание таблицы стран и кол-ва комментаторов в ней
select c.country, count(c.commentator_id) as commentators_count
from commentators c
group by c.country
order by c.country

--15 Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING.
--создание таблицы стран с кол-вом комментаторов > 5 и кол-ва комментаторов в ней
select c.country, count(c.commentator_id) as commentators_count
from commentators c
group by c.country
having count(c.commentator_id) > 5
order by commentators_count
				 
--16 Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений.
--Добавление игрока в таблицу игроков
insert into players (nickname, first_name, second_name, country, age, main_role, rating)
					 values('Inlucker', 'Arseny', 'Pronin', 'Russian Federation', 18, 'OffLaner', 7000);

delete from players where nickname = 'Inlucker'

--17 Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса.
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

--18 	Простая инструкция UPDATE.
--Обновление названия для Российской команды с наибольшим id
update teams
set name = 'Virtus Pro'
where team_id = (select max(team_id)
				 from teams
				 where country = 'Russian Federation')
				 
--19 Инструкция UPDATE со скалярным подзапросом в предложении SET.
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

--20 Простая инструкция DELETE.
--Удаление игрково с ником 'Inlucker'
delete from players
where nickname = 'Inlucker'

insert into players (nickname, first_name, second_name, country, age, main_role, rating)
					 values('Inlucker', 'Arseny', 'Pronin', 'Russian Federation', 18, 'OffLaner', 7000);

--21 Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE.
--Удаление игроков из России с рейтингом > 4000 из всех команд
delete from playersteams 
where player_id in (select p.player_id
					from players p 
					where p.country = 'Russian Federation' and p.rating > 4000)
					
--22 Инструкция SELECT, использующая простое обобщенное табличное выражение
--Посчитать среднее кол-во игроков в командах (в которых есть хотябы один игрок)
with team_players_count(team_id, team_name, players_count) as
(
	select t.team_id, t.name, count(pt.player_id) as player_count
	from teams t join playersteams pt on t.team_id = pt.team_id
	group by t.team_id
	order by t.team_id
)
select avg(players_count) as avg_players_count_in_teams
from team_players_count

--23 Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение.
--Победил победителя...
with recursive rec(winner_id, team1_id, team2_id, level) as
(
	select winner_id, team1_id, team2_id, 0 as level
	from matches as m
	where winner_id = 2
	
	union all 
	
	select m.winner_id, m.team1_id, m.team2_id, level + 1
	from matches as m inner join rec as r on ((m.team1_id = r.winner_id and m.winner_id != r.winner_id) or (m.team2_id = r.winner_id and m.winner_id != r.winner_id))
)
select winner_id, team1_id, team2_id, level
from rec

--бесконечная рекурсия)
with recursive rec(player_id, nickname, age) as
(
	select p.player_id, p.nickname, p.age
	from players as p 
	where country = 'Albania'
	
	union all 
	
	select p.player_id, p.nickname, p.age+1
	from players as p inner join rec as r on p.player_id = r.age
)
select player_id, nickname, age
from rec

--test
create schema dbo
-- Создание таблицы.
CREATE TABLE dbo.MyEmployees (
	EmployeeID smallint NOT NULL,
	FirstName varchar(30) NOT NULL,
	LastName varchar(40) NOT NULL,
	Title varchar(50) NOT NULL,
	DeptID smallint NOT NULL,
	ManagerID int NULL,
	CONSTRAINT PK_EmployeeID PRIMARY KEY (EmployeeID)
);
-- Заполнение таблицы значениями.
INSERT INTO dbo.MyEmployees
VALUES (18, 'Иван', 'Петров', 'Главный исполнительный директор',16, 19);
-- Определение ОТВ
with recursive DirectReports (ManagerID, EmployeeID, Title, DeptID, Level) AS
(
	-- Определение закрепленного элемента
	SELECT e.ManagerID, e.EmployeeID, e.Title, e.DeptID, 0 AS Level
	FROM dbo.MyEmployees AS e
	WHERE ManagerID IS NULL
	UNION ALL
	-- Определение рекурсивного элемента
	SELECT e.ManagerID, e.EmployeeID, e.Title, e.DeptID, Level + 1
	FROM dbo.MyEmployees AS e INNER JOIN DirectReports AS d
		ON e.ManagerID = d.EmployeeID
)
-- Инструкция, использующая ОТВ
SELECT ManagerID, EmployeeID, Title, DeptID, Level
FROM DirectReports;

--24 Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
--средние возраста для ролей
select distinct main_role,
	avg(age) over(partition by p.main_role) as AvgAge,
	min(age) over(partition by p.main_role) as MinAge,
	max(age) over(partition by p.main_role) as MaxAge
from players p 

--Таблица для сравнениея рейтинга игроков на конкретных ролях
select player_id, nickname, main_role, rating,
	avg(rating) over(partition by p.main_role) as avg_rating,
	min(rating) over(partition by p.main_role) as min_rating,
	max(rating) over(partition by p.main_role) as max_rating	
from players p 

--25 Оконные функции для устранения дублей
--Оконные функции для устранения дублей
select player_id, nickname
from
(
	select * 
	from (select pt.player_id, p.nickname,
		  row_number() over (partition by pt.player_id) as row
		  from players as p join playersteams as pt on p.player_id = pt.player_id) as ppt
		where row = 1
) as ppt2

	  
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