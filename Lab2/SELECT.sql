--1 ���������� SELECT, ������������ �������� ���������.
--��� ������ �� ����������
SELECT DISTINCT P.country, P.nickname
FROM public.players AS P
WHERE P.Country = 'Portugal'
ORDER BY P.country, P.nickname

--2 ���������� SELECT, ������������ �������� BETWEEN.
--��� ����� ��������� � ���
SELECT DISTINCT tournament_name, date
FROM matches
WHERE date BETWEEN '2021-05-01' AND '2021-05-31'
ORDER BY date

--3 ���������� SELECT, ������������ �������� LIKE.
--��� ������ � ������, ������������ ��  'lo'
select distinct nickname
from players
where nickname like 'lo%'
ORDER BY nickname

--4 ���������� SELECT, ������������ �������� IN � ��������� �����������.
--����� ��� ����� �� ������� ��������� ������� ���������� > 5000, c ���������� ������������� (12)
select *
from matches
where winner_id in (select team_id
					from teams
					where avg_rating > 5000)
		and commentator_id = 12
		
--5 ���������� SELECT, ������������ �������� EXISTS � ��������� �����������.
--����� ���� ������, ������� �������� ������ 1 ���
select team_id, name
from teams t
where exists (select team_id
			  from matches m
			  where t.team_id = m.winner_id)
			  
--6 ���������� SELECT, ������������ �������� ��������� � ���������.
--����� ������� ��� ������� ������ ��� � ���� �������������
select nickname, rating
from players
where rating > all (select rating
					from players
					where country = 'Afghanistan')
					
--7 ���������� SELECT, ������������ ���������� ������� � ���������� ��������.
--������� �������� �������� ������� �� ����������
select avg(rating) as actual_avg,
	   sum(rating)/count(player_id) as calc_avg
from players
where country = 'Portugal'

--8 ���������� SELECT, ������������ ��������� ���������� � ���������� ��������.
--� �������� �������� ������� ������ � ��������� > 3500
select p.player_id, nickname,
		(select count(*)
		 from playersteams as pt
		 where p.player_id = pt.player_id)
from players p
where rating > 3500

--9 ���������� SELECT, ������������ ������� ��������� CASE.
--���������� �� ������� � �������������� :)
select nickname,
	case country
		when 'Russian Federation' then 'Russian'
		else 'Alien'
	end as nation
from commentators

--10 ���������� SELECT, ������������ ��������� ��������� CASE.
--���������� �� ������� ������ ������ ���� �� ��������
select nickname,
	case
		when rating <= 2000 then 'lowskill'
		when rating <= 4500 then 'avgskill'
		when rating <= 7000 then 'highskill'
		else 'godskill'
	end as skill
from players

--11 �������� ����� ��������� ��������� ������� �� ��������������� ������ ������ ���������� SELECT.
--�������� ������� ���-�� ������ � ������ �������, ������ � ����� �������
select t.team_id, t.name, count(pt.player_id) as player_count
into team_players_count
from teams t join playersteams pt on t.team_id = pt.team_id
group by t.team_id
order by t.team_id

drop table public.team_players_count cascade;


--����� ���-�� ������ � ������� ������������ �����������
select c.commentator_id, c.nickname, count(mc.commentator_id) as matches_count
from commentators c join (select m.commentator_id
						 from matches m) as mc on c.commentator_id = mc.commentator_id
group by c.commentator_id
order by matches_count desc

--12 ���������� SELECT, ������������ ��������� ��������������� ���������� � �������� ����������� ������ � ����������� FROM. (?)
--����
select *
from playersteams pt
where --cur_role = 'MidLaner' and
	  player_id in (select player_id
	  				from players p
	  				where rating > 7000
	  				and pt.cur_role = 'MidLaner')

--����� �������, ������� ������� � �������� �� �����������
select p.player_id, p.nickname, p.rating
from players p join (select player_id, team_id
				   from playersteams pt
				   where team_id in (select team_id
				   					 from teams t
				   					 where country = 'Afghanistan')) as af_teams on p.player_id = af_teams.player_id

--����� �������, ������� ������� � �������� �� ����������� � ����� ������� ���� 'HardSupport'
select p.player_id, p.nickname, p.rating
from players p join (select player_id, team_id
				   from playersteams pt
				   where team_id in (select team_id
				   					 from teams t
				   					 where country = 'Afghanistan' and
				   					 pt.cur_role = 'HardSupport')) as af_teams on p.player_id = af_teams.player_id

--13 ���������� SELECT, ������������ ��������� ���������� � ������� ����������� 3.
--����� ������ � �������� ������ �������, �������� > 7500 ��������
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

--14 ���������� SELECT, ��������������� ������ � ������� ����������� GROUP BY, �� ��� ����������� HAVING.
--�������� ������� ����� � ���-�� ������������� � ���
select c.country, count(c.commentator_id) as commentators_count
from commentators c
group by c.country
order by c.country

--15 ���������� SELECT, ��������������� ������ � ������� ����������� GROUP BY � ����������� HAVING.
--�������� ������� ����� � ���-��� ������������� > 5 � ���-�� ������������� � ���
select c.country, count(c.commentator_id) as commentators_count
from commentators c
group by c.country
having count(c.commentator_id) > 5
order by commentators_count
				 
--16 ������������ ���������� INSERT, ����������� ������� � ������� ����� ������ ��������.
--���������� ������ � ������� �������
insert into players (nickname, first_name, second_name, country, age, main_role, rating)
					 values('Inlucker', 'Arseny', 'Pronin', 'Russian Federation', 18, 'OffLaner', 7000);

delete from players where nickname = 'Inlucker'

--17 ������������� ���������� INSERT, ����������� ������� � ������� ��������������� ������ ������ ���������� ����������.
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

--���������� ������� �� ������ � ��������� > 4000 � ���������� ������� � ���������� id
insert into playersteams (team_id, player_id, cur_role)
select (select max(team_id)
		from teams
		where country = 'Russian Federation'), p.player_id, p.main_role 
from players p 
where p.country = 'Russian Federation' and p.rating > 4000

--18 	������� ���������� UPDATE.
--���������� �������� ��� ���������� ������� � ���������� id
update teams
set name = 'Virtus Pro'
where team_id = (select max(team_id)
				 from teams
				 where country = 'Russian Federation')
				 
--19 ���������� UPDATE �� ��������� ����������� � ����������� SET.
--���������� �������� ������� �������� ��� ���������� ������� � ���������� id
update teams
set avg_rating = (select avg(rating)
				  from players p join playersteams pt
				  on p.player_id = pt.player_id and team_id = (select max(team_id)
															   from teams
															   where country = 'Russian Federation'))
where team_id = (select max(team_id)
				 from teams
				 where country = 'Russian Federation')

--20 ������� ���������� DELETE.
--�������� ������� � ����� 'Inlucker'
delete from players
where nickname = 'Inlucker'

insert into players (nickname, first_name, second_name, country, age, main_role, rating)
					 values('Inlucker', 'Arseny', 'Pronin', 'Russian Federation', 18, 'OffLaner', 7000);

--21 ���������� DELETE � ��������� ��������������� ����������� � ����������� WHERE.
--�������� ������� �� ������ � ��������� > 4000 �� ���� ������
delete from playersteams 
where player_id in (select p.player_id
					from players p 
					where p.country = 'Russian Federation' and p.rating > 4000)
					
--22 ���������� SELECT, ������������ ������� ���������� ��������� ���������
--��������� ������� ���-�� ������� � �������� (� ������� ���� ������ ���� �����)
with team_players_count(team_id, team_name, players_count) as
(
	select t.team_id, t.name, count(pt.player_id) as player_count
	from teams t join playersteams pt on t.team_id = pt.team_id
	group by t.team_id
	order by t.team_id
)
select avg(players_count) as avg_players_count_in_teams
from team_players_count

--23 ���������� SELECT, ������������ ����������� ���������� ��������� ���������.
--������� ����������...
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

--����������� ��������)
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
-- �������� �������.
CREATE TABLE dbo.MyEmployees (
	EmployeeID smallint NOT NULL,
	FirstName varchar(30) NOT NULL,
	LastName varchar(40) NOT NULL,
	Title varchar(50) NOT NULL,
	DeptID smallint NOT NULL,
	ManagerID int NULL,
	CONSTRAINT PK_EmployeeID PRIMARY KEY (EmployeeID)
);
-- ���������� ������� ����������.
INSERT INTO dbo.MyEmployees
VALUES (18, '����', '������', '������� �������������� ��������',16, 19);
-- ����������� ���
with recursive DirectReports (ManagerID, EmployeeID, Title, DeptID, Level) AS
(
	-- ����������� ������������� ��������
	SELECT e.ManagerID, e.EmployeeID, e.Title, e.DeptID, 0 AS Level
	FROM dbo.MyEmployees AS e
	WHERE ManagerID IS NULL
	UNION ALL
	-- ����������� ������������ ��������
	SELECT e.ManagerID, e.EmployeeID, e.Title, e.DeptID, Level + 1
	FROM dbo.MyEmployees AS e INNER JOIN DirectReports AS d
		ON e.ManagerID = d.EmployeeID
)
-- ����������, ������������ ���
SELECT ManagerID, EmployeeID, Title, DeptID, Level
FROM DirectReports;

--24 ������� �������. ������������� ����������� MIN/MAX/AVG OVER()
--������� �������� ��� �����
select distinct main_role,
	avg(age) over(partition by p.main_role) as AvgAge,
	min(age) over(partition by p.main_role) as MinAge,
	max(age) over(partition by p.main_role) as MaxAge
from players p 

--������� ��� ���������� �������� ������� �� ���������� �����
select player_id, nickname, main_role, rating,
	avg(rating) over(partition by p.main_role) as avg_rating,
	min(rating) over(partition by p.main_role) as min_rating,
	max(rating) over(partition by p.main_role) as max_rating	
from players p 

--25 ������� ������� ��� ���������� ������
--������� ������� ��� ���������� ������
select player_id, nickname
from
(
	select * 
	from (select pt.player_id, p.nickname,
		  row_number() over (partition by pt.player_id) as row
		  from players as p join playersteams as pt on p.player_id = pt.player_id) as ppt
		where row = 1
) as ppt2

	  
--�������� ������� ����� ������ � �������������� �� ��� ������
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