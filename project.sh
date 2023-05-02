#!/bin/bash

#awk -F ';' '{ print $1 " " $2 " " $3 " " $4 }' "accounts.csv" > parsed.txt


#awf (data file parsing) : -F -> field separator ; NR>1 : row>1 ; $1 : column 1

#awk -F ';' 'NR>1 {print $1}' "accounts.csv" > names.txt
#awk -F ';' 'NR>1 {print $2}' "accounts.csv" > surnames.txt
#awk -F ';' 'NR>1 {print $3}' "accounts.csv" > mails.txt
#awk -F ';' 'NR>1 {print $4}' "accounts.csv" > passwords.txt

#while read : execution a chaque ligne ; -r : text brut sans interpretation des \ par exemple
tail -n +2 accounts.csv | while IFS=';' read -r NAME SURNAME MAIL PASSWORD; do
    #username="$NAME"
    username=${NAME:0:1}$(echo "$SURNAME" | sed 's/ //g')
    echo "$username"
    #sudo adduser 
    #echo "$NAME $SURNAME $MAIL $PASSWORD"
done

