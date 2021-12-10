'''
from faker import Faker
fake = Faker()

for _ in range(10):
  print(fake.name())
'''

import psycopg2
from psycopg2 import OperationalError
import csv
import time

def create_connection(db_name, db_user, db_password, db_host, db_port):
    connection = None
    try:
        connection = psycopg2.connect(
            database=db_name,
            user=db_user,
            password=db_password,
            host=db_host,
            port=db_port,
        )
        print("Connection to PostgreSQL DB successful")
    except OperationalError as e:
        print(f"The error '{e}' occurred")
    return connection

def execute_query(connection, query):
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        connection.commit()
        print("Query executed successfully")
    except OperationalError as e:
        print(f"The error '{e}' occurred")

connection = create_connection("postgres", "postgres", "postgres", "localhost", "5432")

create_players_table = """
create table public.Players
(
	player_id int primary key,
	nickname text,
	first_name text,
	second_name text,
	country text,
	age int,
	main_role text,
	rating int
);
"""
#execute_query(connection, create_players_table)

insert_player = """
insert into public.Players values(0,
				  'Inlucker',
				  'Arseny',
				  'Pronin',
				  'Russia',
				  18,
				  'OffLaner',
				  7000);
"""
execute_query(connection, insert_player)

time.sleep(5)

delete_player = """
delete
from players
where player_id = 0;
"""
execute_query(connection, delete_player)


#sql = "COPY (SELECT * FROM public.Players) TO STDOUT WITH CSV DELIMITER ';';"
#with open("./table.csv", "w") as file:
#    cur.copy_expert(sql, file)
#execute_query(connection, sql)
