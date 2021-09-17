from faker import Faker
from random import randint
from random import uniform
from random import choice

RECORDS_N = 100

role = ["SafeLaner", "MidLaner", "OffLaner", "SoftSupport", "HardSupport"]

def generate_players():
    faker = Faker()
    f = open('players.csv', 'w')
    for i in range(RECORDS_N):
        age = randint(0, 111)
        rating = randint(0, 8000)
        line = "{0},{1},{2},{3},{4},{5},{6}\n".format(
                                                  faker.language_name(),
                                                  faker.first_name_male(),
                                                  faker.last_name_male(),
                                                  faker.country(),
                                                  age,
                                                  choice(role),
                                                  rating)
        f.write(line)
    f.close()
    
generate_players()
