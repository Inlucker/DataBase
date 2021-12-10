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

def execute_read_query(connection, query):
    cursor = connection.cursor()
    result = None
    try:
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    except Error as e:
        print(f"The error '{e}' occurred")

#1) Минимальный возраст среди игроков
def f1():
    q1 = """select min(age) from players"""
    return execute_read_query(connection, q1)

#2) Получить таблицу ников игрков и соответсвующих им имён команд
def f2():
    q2 ="""
        select distinct p.player_id, nickname as player_nickname, t.team_id, t.name as team_name
        from players p join playersteams pt on p.player_id = pt.player_id join teams t on t.team_id = pt.team_id 
        order by p.player_id, t.team_id
        """
    return execute_read_query(connection, q2)

#3) Посчитать среднее кол-во игроков в командах (в которых есть хотябы один игрок)
def f3():
    q3 ="""
        with team_players_count(team_id, team_name, players_count) as
        (
                select t.team_id, t.name, count(pt.player_id) as player_count
                from teams t join playersteams pt on t.team_id = pt.team_id
                group by t.team_id
                order by t.team_id
        )
        select avg(players_count) as avg_players_count_in_teams
        from team_players_count
        """
    return execute_read_query(connection, q3)

#4) Только мои view
def f4():
    q4 ="""
        SELECT table_schema, table_name
        FROM INFORMATION_SCHEMA.tables
        WHERE table_type='VIEW' AND table_schema=ANY(current_schemas(false))
        ORDER BY table_name;
        """
    return execute_read_query(connection, q4)

#5) Минимальный возраст среди игроков
def f5():
    q5 ="""
        select minAge();
        """
    return execute_read_query(connection, q5)

#6) Самые молодые игроки
def f6():
    q6 ="""
        select nickname, age from YoungPlayers();
        """
    return execute_read_query(connection, q6)

#7) бновить средний рейтинг команды по id
def f7(team_id):
    q7 ="""
        call updateAvgRating({0});
        """.format(team_id)
    execute_query(connection, q7)
    
#8) Системный вызов current_database()
def f8():
    q8 ="""
        select current_database();
        """
    return execute_read_query(connection, q8)

#9) Создадим таблицу турниров
def f9():
    q9 ="""
        create table if not exists Tournaments
        (
                tournament_id serial primary key,
                name text,
                country text,
                city text,
                prize_pool text,
                start_date date,
                end_date date
        );
        """
    execute_query(connection, q9)

#10) Наполним таблицу турниров
def f10():
    q10 ="""
        insert into Tournaments (name, country, city, prize_pool, start_date, end_date)
        values('The International 10', 'Romania', 'Bucharest', '$40,018,195 USD', '10-07-2021', '10-17-2021');
        insert into Tournaments (name, country, city, prize_pool, start_date, end_date)
        values('EPICENTER', 'Russia', 'Moscow ', '$1,000,000 USD', '06-22-2019', '06-30-2019');
        """
    execute_query(connection, q10)


connection = create_connection("postgres", "postgres", "postgres", "localhost", "5432")

n = int(input("Введите номер запроса: "));

while (n > 0 and n <= 10):
    if (n == 1):
        rez = f1()
        print(rez)
    elif (n == 2):
        rez = f2()
        print(rez)
    elif (n == 3):
        rez = f3()
        print(rez)
    elif (n == 4):
        rez = f4()
        print(rez)
    elif (n == 5):
        rez = f5()
        print(rez)
    elif (n == 6):
        rez = f6()
        print(rez)
    elif (n == 7):
        tid = input("Введите id команды: ")
        f7(tid)
    elif (n == 8):
        rez = f8()
        print(rez)
    elif (n == 9):
        f9()
    elif (n == 10):
        f10()
    
    n = int(input("Введите номер запроса: "));

print("Exited...")
