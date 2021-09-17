create table public.Игроки
(
	player_id int primary key,
	Псевдоним text,
	ФИО text,
	Страна text,
	Возраст int,
	Роль text,
	Рейтинг int
);

insert into public.Игроки(player_id, Рейтинг) values(-1, -100);
insert into public.Игроки(player_id, Псевдоним, ФИО, Страна, Возраст, Роль, Рейтинг)
				   values(3, 'Inlucker', 'FIO', 'Rus', 18, 'Offlaner', 7000);

create table public.Команды
(
	team_id int primary key,
	Название text,
	Страна text,
	Спонсор text,
	Средний_рейтинг int
);

create table public.ИгрокиКоманды
(
	player_id int,
	team_id int,
	FOREIGN KEY (player_id) REFERENCES public.Игроки (player_id),
	FOREIGN KEY (team_id) REFERENCES public.Команды (team_id),
	Роль text
);

create table public.Комментаторы
(
	Id_комментатора int primary key,
	Псевдоним text,
	ФИО text,
	Страна text
);

create table public.Матчи
(
	Id_команды1 int,
	Id_команды2 int,
	Id_победителя int,
	Id_коментатора int,
	FOREIGN KEY (Id_команды1) REFERENCES public.Команды (team_id),
	FOREIGN KEY (Id_команды2) REFERENCES public.Команды (team_id),
	FOREIGN KEY (Id_победителя) REFERENCES public.Команды (team_id),
	FOREIGN KEY (Id_коментатора) REFERENCES public.Комментаторы (Id_комментатора),
	Название_турнира text,
	Дата text
);

drop table public.Игроки cascade;
drop table public.Команды cascade;
drop table public.ИгрокиКоманды cascade;
drop table public.Комментаторы cascade;
drop table public.Матчи cascade;