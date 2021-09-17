from faker import Faker
from random import randint
from random import uniform
from random import choice

MAX_N = 1000

sex = ['m', 'f']


def generate_people():
    faker = Faker()
    f = open('people.csv', 'w')
    for i in range(MAX_N):
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
    
generate_people()