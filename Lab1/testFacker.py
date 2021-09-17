from faker import Faker
from random import randint
from random import uniform
from random import choice

RECORDS_N = 10

sex = ['m', 'f']


def generate_people():
    faker = Faker()
    f = open('people.csv', 'w')
    for i in range(RECORDS_N):
        age = randint(0, 111)
        h = randint(40, 250)
        w = h * h * 0.00225 + randint(0, 15)
        calorie_norm = randint(1000,3000)
        line = "{0},{1},{2},{3},{4},{5}\n".format(
                                                  faker.name(),
                                                  choice(sex),
                                                  age,
                                                  h,
                                                  int(w),
                                                  calorie_norm)
        f.write(line)
    f.close()

def gen_role():
    role = randint(1, 5)
    if role == 1:
        return("SafeLaner")
    elif role == 2:
        return("MidLaner")
    elif role == 3:
        return("OffLaner")
    elif role == 4:
        return("SoftSupport")
    elif role == 5:
        return("HardSupport")

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
                                                  gen_role(),
                                                  rating)
        f.write(line)
    f.close()
    
#generate_people()
generate_players()
