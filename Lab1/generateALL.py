from genPlayers import generatePlayers
from genTeams import generateTeams
from genPlayersTeams import generatePlayersTeams
from genCommentators import generateCommentators
from genMatches import generateMatches

RECORDS_N = 1000

players = generatePlayers(RECORDS_N)
players_teams = generatePlayersTeams(RECORDS_N, players)
generateTeams(RECORDS_N, players_teams)
generateCommentators(RECORDS_N)
generateMatches(RECORDS_N)
