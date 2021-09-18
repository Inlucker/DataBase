from faker import Faker
from random import randint
from random import choice

def genTeamName(faker):
    name = ''
    for i in range (randint(1, 2)):
        name += faker.word() + ' '
    return name.capitalize()
        

def generateTeams(records_number, players_teams):
    faker = Faker()
    f = open('teams.csv', 'w')
    for i in range(records_number):
        #avg_rating = randint(1, 8000)
        avg_rating = 0
        if (i+1) in players_teams:
            n = len(players_teams[i+1])
            players_in_team = players_teams[i+1]
            for i in players_in_team:
                avg_rating += i
            avg_rating = int(avg_rating/n)
        else:
            avg_rating = ''
        line = "{0}|{1}|{2}|{3}\n".format(genTeamName(faker),
                                          faker.country(),
                                          faker.company(),
                                          avg_rating)
        f.write(line)
    f.close()
    print("Finished generating Teams")
