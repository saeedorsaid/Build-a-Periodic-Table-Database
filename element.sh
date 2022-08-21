#! /bin/bash

if [[ $1 ]]
then 
  if [[ $1 =~ ^[0-9]+$ ]]
  then 
    echo This is a number.
  else 
    echo This is not a number.
  fi
else
  echo Please provide an element as an argument.
fi