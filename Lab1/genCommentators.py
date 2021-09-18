from faker import Faker
from random import randint
from random import choice

def generateCommentators(records_number):
    faker = Faker()
    f = open('Commentators.csv', 'w')
    for i in range(records_number):
        age = randint(9, 100)
        popularity = randint(1, 8000)
        line = "{0}|{1}|{2}|{3}|{4}|{5}\n".format(faker.user_name(),
                                          faker.first_name_male(),
                                          faker.last_name_male(),
                                          faker.country(),
                                          age,
                                          popularity)
        f.write(line)
    f.close()
    print("Finished generating Commentators")
