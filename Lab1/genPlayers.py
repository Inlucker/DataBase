from faker import Faker
from random import randint
from random import choice

role = ["SafeLaner", "MidLaner", "OffLaner", "SoftSupport", "HardSupport"]

def generatePlayers(records_number):
    players = dict()
    faker = Faker()
    f = open('players.csv', 'w')
    for i in range(records_number):
        age = randint(9, 100)
        rating = randint(1, 8000)
        line = "{0}|{1}|{2}|{3}|{4}|{5}|{6}\n".format(faker.user_name(),
                                                      faker.first_name_male(),
                                                      faker.last_name_male(),
                                                      faker.country(),
                                                      age,
                                                      choice(role),
                                                      rating)
        players[i+1] = rating
        f.write(line)
    f.close()
    print("Finished generating Players")
    return players
