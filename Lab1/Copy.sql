COPY public.Players TO STDOUT (DELIMITER '|');

create table if not exists people (
	id serial not null primary key,
	name varchar(30) not null,
	sex char,
	age integer check (age>=0 and age <= 111),
	height integer check (height > 30 and height < 300) default 165,
	weight real check (weight > 0 and weight < 500),
	calories int default 2000
);
--copy people(name, sex, age, height, weight, calories) from '/people.csv' delimiter ',' csv;

--copy public.Players(nickname, first_name, second_name, country, age, main_role, rating) from '/players.csv' delimiter ',' csv;