from faker import Faker
from random import randint
from random import choice

def genTeamName(faker):
    name = ''
    for i in range (randint(1, 2)):
        name += faker.word() + ' ';
    return name.capitalize()
        

def generateTeams(records_number):
    faker = Faker()
    f = open('teams.csv', 'w')
    for i in range(records_number):
        avg_rating = randint(1, 8000)
        line = "{0}|{1}|{2}|{3}\n".format(genTeamName(faker),
                                          faker.country(),
                                          faker.company(),
                                          avg_rating)
        f.write(line)
    f.close()
    print("Finished generating Teams")
