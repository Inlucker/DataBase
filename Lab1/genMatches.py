from faker import Faker
from random import randint
from random import choice
import datetime

def checkDate(date):
    #year, month, day = map(int, date.split('-'))
    year, month, day = date.year, date.month, date.day
    now = datetime.datetime.now()
    winner_flag = False
    if (year < now.year):
        winner_flag = True
    elif (year > now.year):
        winner_flag = False
    else:
        if (month < now.month):
            winner_flag = True
        elif (month > now.month):
            winner_flag = False
        else:
            if (day < now.day):
                winner_flag = True
            elif (day > now.day):
                winner_flag = False
    return winner_flag
                    
def generateMatches(records_number):
    faker = Faker()
    f = open('Matches.csv', 'w')
    for i in range(records_number):
        team1_id = randint(1, records_number)
        team2_id = randint(1, records_number)
        commentator_id = randint(1, records_number)
        date = faker.date_this_year(True, True)
        winner = ''
        popularity = randint(1, 8000)
        if (checkDate(date)):
            winner = choice([team1_id, team2_id])
        
            
        line = "{0}|{1}|{2}|{3}|{4}|{5}|{6}\n".format(team1_id,
                                                  team2_id,
                                                  winner,
                                                  commentator_id,
                                                  faker.word().capitalize(),
                                                  date,
                                                  popularity)
        f.write(line)
    f.close()
    print("Finished generating Mathces")

#generateMatches(1000)
