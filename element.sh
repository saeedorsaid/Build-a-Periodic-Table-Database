#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then 
  # check if argument is an atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then 
    SYMBOL=$(echo $($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1") | sed 's/ //g')
    # if not found
    if [[ -z $SYMBOL ]]
    then 
      echo "I could not find that element in the database."
    else
      NAME=$(echo $($PSQL "SELECT name FROM elements WHERE atomic_number=$1") | sed 's/ //g')
      INFO=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$1")
      echo "$INFO" | while read ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID
      do 
        TYPE=$(echo $($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID") | sed 's/ //g')
        echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."	
      done 
    fi
  fi
  # check if argument is a symbol
  if [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then 
    NAME=$(echo $($PSQL "SELECT name FROM elements WHERE symbol='$1'") | sed 's/ //g')
    # if not found
    if [[ -z $NAME ]]
    then 
      echo "I could not find that element in the database."
    else 
      ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'") | sed 's/ //g')
      INFO=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      echo "$INFO" | while read ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID
      do 
        TYPE=$(echo $($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID") | sed 's/ //g')
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($1). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."	
      done 
    fi    
  fi
  # check if argument is an element name
  if [[ $1 =~ ^[A-Z][a-z][a-z]+ ]]
  then 
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE name='$1'") | sed 's/ //g')
    # if not found
    if [[ -z $ATOMIC_NUMBER ]]
    then 
      echo "I could not find that element in the database."
    else     
      SYMBOL=$(echo $($PSQL "SELECT symbol FROM elements WHERE name='$1'") | sed 's/ //g')
      INFO=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      echo "$INFO" | while read ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID
      do 
        TYPE=$(echo $($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID") | sed 's/ //g')
        echo "The element with atomic number $ATOMIC_NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $1 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."	
      done   
    fi 
  fi
else
  echo Please provide an element as an argument.
fi