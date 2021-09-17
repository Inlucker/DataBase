from faker import Faker
from random import randint
from random import choice

role = ["SafeLaner", "MidLaner", "OffLaner", "SoftSupport", "HardSupport"]   

def generatePlayersTeams(records_number):
    faker = Faker()
    f = open('PlayersTeams.csv', 'w')
    for i in range(records_number):
        player_id = randint(1, records_number)
        team_id = randint(1, records_number)
        line = "{0}|{1}|{2}\n".format(player_id,
                                      team_id,
                                      choice(role))
        f.write(line)
    f.close()
    print("Finished generating PlayersTeams")
