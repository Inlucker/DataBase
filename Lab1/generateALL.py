from genPlayers import generatePlayers
from genTeams import generateTeams
from genPlayersTeams import generatePlayersTeams
from genCommentators import generateCommentators
from genMatches import generateMatches

RECORDS_N = 1000

generatePlayers(RECORDS_N)
generateTeams(RECORDS_N)
generatePlayersTeams(RECORDS_N)
generateCommentators(RECORDS_N)
generateMatches(RECORDS_N)
