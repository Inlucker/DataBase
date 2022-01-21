from peewee import *

# Подключаемся к нашей БД.
con = PostgresqlDatabase(
    database='postgres',
    user='postgres',
    password='postgres',
    host='127.0.0.1',
    port=5432
)


class BaseModel(Model):
    class Meta:
        database = con


class Players(BaseModel):
    player_id = IntegerField(column_name='player_id')
    nickname = TextField(column_name='nickname')
    first_name = TextField(column_name='first_name')
    second_name = TextField(column_name='second_name')
    country = TextField(column_name='country')
    age = IntegerField(column_name='age')
    main_role = TextField(column_name='main_role')
    rating = IntegerField(column_name='rating')

    class Meta:
        table_name = 'players'


class Teams(BaseModel):
    team_id = IntegerField(column_name='team_id')
    name = TextField(column_name='name')
    country = TextField(column_name='country')
    sponsor = TextField(column_name='sponsor')
    avg_rating = IntegerField(column_name='avg_rating')

    class Meta:
        table_name = 'teams'

class PlayersTeams(BaseModel):
    player_id = IntegerField(column_name='team_id')
    team_id = IntegerField(column_name='name')
    cur_role = IntegerField(column_name='cur_role')

    class Meta:
        table_name = 'playersTeams'

class Commentators(BaseModel):
    commentator_id = IntegerField(column_name='commentator_id')
    nickname = TextField(column_name='nickname')
    first_name = TextField(column_name='first_name')
    second_name = TextField(column_name='second_name')
    country = TextField(column_name='country')
    age = IntegerField(column_name='age')
    popularity = IntegerField(column_name='popularity')

    class Meta:
        table_name = 'commentators'

class Matches(BaseModel):
    team1_id = IntegerField(column_name='team1_id')
    team2_id = IntegerField(column_name='team2_id')
    winner_id = IntegerField(column_name='winner_id')
    commentator_id = IntegerField(column_name='commentator_id')
    tournament_name = TextField(column_name='tournament_name')
    date = TextField(column_name='date')
    popularity = IntegerField(column_name='popularity')

    class Meta:
        table_name = 'Mmatches'


def print_res(cur):
    rows = cur.fetchall()
    for row in rows:
        print(*row)
    print()


def print_query_res(query):
    for elem in query.dicts().execute():
        print(elem)


def main():
    query1 = Players.select(Players.player_id, Players.nickname, Players.age, Players.rating)\
        .where(Players.rating > 3000).where(Players.age == 18)
    print_query_res(query1)

    #query2 = Players.select(Players.nickname, Players.age).join(Teams).where(Players.age == 18)
    #print_query_res(query2)



if __name__ == "__main__":
    main()

con.close()