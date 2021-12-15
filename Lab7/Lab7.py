from py_linq import *

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

def get_players(file_name):
    file = open(file_name, 'r')
    players = list()

    i = 1;
    for line in file:
        row = line.split('|')
        p = player(i, row[0], row[1], row[2], row[3], int(row[4]), row[5], int(row[6]))
        players.append(p.get())
        i+=1
    return players

#PLAYERSTEAMS
class playerteam():
    player_id = int()
    team_id = int()
    cur_role = str()

    def __init__(self, p_id, t_id, cur_role):
        self.player_id = p_id
        self.team_id = t_id
        self.cur_role = cur_role

    def get(self):
        return {'player_id': self.player_id, 'team_id': self.team_id, 'cur_role': self.cur_role}

def get_playersteams(file_name):
    file = open(file_name, 'r')
    playersteams = list()

    for line in file:
        row = line.split('|')
        pt = playerteam(int(row[0]), int(row[1]), row[2])
        playersteams.append(pt.get())
    return playersteams

#TASK 1
#Все игроки с именем, начинающимся на  'lo'
def q1(players):
    rez = players.where(lambda x: x['nickname'].find('lo') == 0)
    return rez

#Выбор игроков чей рейтинг больше чем у всех Афганистанцев
def q2(players):
    rez = players.where(lambda x: x['rating'] > players.where(lambda x: x['country'] == 'Afghanistan').max(lambda x: x['rating']))
    return rez

#Подсчёт среднего рейтинга игроков из Португалии
def q3(players):
    rez = players.where(lambda x: x['country'] == 'Portugal').avg(lambda x: x['rating'])
    return rez

#В скольких командах состоят игркои с рейтингом > 3500
def q4(players, playersteams):
    rez = players.where(lambda x: x['rating'] > 3500).select(lambda x: {x['player_id'], x['nickname'], playersteams.where(lambda y: y['player_id'] == x['player_id']).count()})
    return rez

#Комментаторы по возрасту
def q5(players, age):
    rez = players.where(lambda x: x['age'] == age)
    return rez

players = Enumerable(get_players('../Lab1/players.csv'))
playersteams = Enumerable(get_playersteams('../Lab1/PlayersTeams.csv'))
#for i in playersteams:
#   print(i)

#rez = q1(players)
#rez = q2(players)
#print(q3(players))
#rez = q4(players, playersteams)
rez = q5(players, 18)
for i in rez:
   print(i)

print("OK")