# Prolog Project

It was our project for CMPE260 - PRINCIPLES OF PROGRAMMING LANGUAGES. The goal of this project is giving information about the football teams. There are some existed predicates and also others that we will define.

### Existed ones;
  * team(teamName, hometown)
  * match(week, homeTeam, homeTeamScore, awayTeam, awayTeamScore)
  
### Predicates that we will define;
  * allTeams(listOfTeams, numberOfTeams)
  * wins(team, week, listOfDefeatedTeams, lengthOfList)
  * losses(teams, week, listOfWinnerTeams, lengthOfList)
  * draws(team, week, listOfWinnerTeams, lengthOfList)
  * scored(team, week, numberOfScoresOfTeam)
  * conceded(team, week, numberOfConceded)
  * average(team, week, totalScore)
  * order(teams, week)
  * topThree(teams, week)

#### Examples;
##### ?- allTeams(L, N).
###### L = [realmadrid, juventus, galatasaray, kobenhavn, manutd, realsociedad, shaktard, bleverkusen, omarseille|...],
###### N = 12 ;

##### ?- wins(galatasaray, 6, L , N).
###### L = [kobenhavn, juventus],
###### N = 2.

##### ?- losses(Juventus, 3, L ,N).
###### L = [realmadrid],
###### N = 1.

##### ?- draws(manutd, 4, L, N).
###### L = [],
###### N = 0.

##### ?- scored(realmadrid, 3, S).
###### S = 12.
##### ?- conceded(realmadrid, 3, S).
###### S = 2.
##### ?- average(realmadrid, 3, S).
###### S = 10.

##### ?- order(L, 4).
###### L = [realmadrid, manutd, arsenal, fcnapoli, bdortmund, shaktard, juventus, bleverkusen, galatasaray|...];
###### false.
##### ?- topThree(L, 4).
###### L = [realmadrid, manutd, arsenal];
###### false.

Note: Because prolog is the logic programming, outputs are true and false. If your predicate can be arrived by facts, the output is true. Otherwise, it false. If there are several cases, it gives the possible outputs.
