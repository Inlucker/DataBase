import psycopg2
from psycopg2 import OperationalError
from py_linq import *

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
    except OperationalError as e:
        print(f"The error '{e}' occurred")

#PLAYERS
class player():
    player_id = int()
    nickname = str()
    first_name = str()
    second_name = str()
    country = str()
    age = int()
    main_role = str()
    rating = int()

    def __init__(self, id, nickname, first_name, second_name, country, age, main_role, rating):
        self.player_id = id
        self.nickname = nickname
        self.first_name = first_name
        self.second_name = second_name
        self.country = country
        self.age = age
        self.main_role = main_role
        self.rating = rating

    def get(self):
        return {'player_id': self.player_id, 'nickname': self.nickname, 'first_name': self.first_name,
                'second_name': self.second_name, 'country': self.country, 'age': self.age,
                'main_role': self.main_role, 'rating': self.rating}

#TASK 2
#Чтение из XML/JSON документа.
def read_from_json():
    q = """select row_to_json(p) from players p;"""
    json = execute_read_query(connection, q)
    rez = list()
    for tmp in json:
        i = tmp[0]
        rez.append(player(i['player_id'], i['nickname'], i['first_name'], i['second_name'],
		i['country'], i['age'], i['main_role'], i['rating']).get())
    return rez


def update_json(players):
    for i in players:
        if (i['main_role'] == 'OffLaner'):
            i['rating'] += 23

def add_to_json(players):
    players.append(player(1001, 'Inlucker', 'Arseny', 'Pronin',
		'Russia', '18', 'Offlaner', '6660').get())


connection = create_connection("postgres", "postgres", "postgres", "localhost", "5432")

players = read_from_json()

update_json(players)

add_to_json(players)

for i in players:
    print(i)

connection.close()
print("OK2")