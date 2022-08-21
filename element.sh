#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then 
  if [[ $1 =~ ^[0-9]+$ ]]
  then 
    SYMBOL=$(echo $($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1") | sed 's/ //g')
    NAME=$(echo $($PSQL "SELECT name FROM elements WHERE atomic_number=$1") | sed 's/ //g')
    INFO=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$1")
    echo "$INFO" | while read ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID
    do 
      TYPE=$(echo $($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID") | sed 's/ //g')
      echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."	
    done 
  else 
    echo This is not a number.
  fi
else
  echo Please provide an element as an argument.
fi