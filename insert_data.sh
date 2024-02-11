#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database
#$($PSQL "insert into teams(name) values('mario')")
$PSQL "TRUNCATE TABLE games, teams;"


number=0
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
if [[ $year !=  'year' ]]
then
winnerId=$($PSQL "select team_id from teams where name='$winner'")
opponentId=$($PSQL "select team_id from teams where name='$opponent'")
if [[ -z $winnerId ]]
then
$PSQL "insert into teams(name) values ('$winner')"
(( number++ ))
echo $number winner

elif [[ -z $opponentId ]]
then
$PSQL "insert into teams(name) values ('$opponent')"
(( number++ ))
echo $number oppo
fi
fi
done

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do

winnerId=$($PSQL "select team_id from teams where name='$winner'")
opponentId=$($PSQL "select team_id from teams where name='$opponent'")

$PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals)
 values($year,'$round',$winnerId,$opponentId,$winner_goals,$opponent_goals)"
echo yes

done
