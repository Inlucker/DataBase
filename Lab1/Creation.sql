create table public.������
(
	player_id int primary key,
	��������� text,
	��� text,
	������ text,
	������� int,
	���� text,
	������� int
);

insert into public.������(player_id, �������) values(-1, -100);
insert into public.������(player_id, ���������, ���, ������, �������, ����, �������)
				   values(3, 'Inlucker', 'FIO', 'Rus', 18, 'Offlaner', 7000);

create table public.�������
(
	team_id int primary key,
	�������� text,
	������ text,
	������� text,
	�������_������� int
);

create table public.�������������
(
	player_id int,
	team_id int,
	FOREIGN KEY (player_id) REFERENCES public.������ (player_id),
	FOREIGN KEY (team_id) REFERENCES public.������� (team_id),
	���� text
);

create table public.������������
(
	Id_������������ int primary key,
	��������� text,
	��� text,
	������ text
);

create table public.�����
(
	Id_�������1 int,
	Id_�������2 int,
	Id_���������� int,
	Id_����������� int,
	FOREIGN KEY (Id_�������1) REFERENCES public.������� (team_id),
	FOREIGN KEY (Id_�������2) REFERENCES public.������� (team_id),
	FOREIGN KEY (Id_����������) REFERENCES public.������� (team_id),
	FOREIGN KEY (Id_�����������) REFERENCES public.������������ (Id_������������),
	��������_������� text,
	���� text
);

drop table public.������ cascade;
drop table public.������� cascade;
drop table public.������������� cascade;
drop table public.������������ cascade;
drop table public.����� cascade;