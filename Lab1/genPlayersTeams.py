from faker import Faker
from random import randint
from random import choice

role = ["SafeLaner", "MidLaner", "OffLaner", "SoftSupport", "HardSupport"]   

def generatePlayersTeams(records_number, players):
    faker = Faker()
    players_teams = dict()
    f = open('PlayersTeams.csv', 'w')
    for i in range(records_number):
        player_id = randint(1, records_number)
        team_id = randint(1, records_number)
        line = "{0}|{1}|{2}\n".format(player_id,
                                      team_id,
                                      choice(role))
        if team_id in players_teams:
            players_teams[team_id].append(players[player_id])
        else:
            players_teams[team_id] = [players[player_id]]
        
        f.write(line)
    f.close()
    print("Finished generating PlayersTeams")
    return players_teams
