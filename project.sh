#!/bin/bash

#awk -F ';' '{ print $1 " " $2 " " $3 " " $4 }' "accounts.csv" > parsed.txt


#awf (data file parsing) : -F -> field separator ; NR>1 : row>1 ; $1 : column 1

#awk -F ';' 'NR>1 {print $1}' "accounts.csv" > names.txt
#awk -F ';' 'NR>1 {print $2}' "accounts.csv" > surnames.txt
#awk -F ';' 'NR>1 {print $3}' "accounts.csv" > mails.txt
#awk -F ';' 'NR>1 {print $4}' "accounts.csv" > passwords.txt

#while read : execution a chaque ligne ; -r : text brut sans interpretation des \ par exemple
tail -n +2 accounts.csv | while IFS=';' read -r NAME SURNAME MAIL PASSWORD; do
    username=${NAME:0:1}$(echo "$SURNAME") # prend la premiere lettre du prenom et le nom
    username=$(echo "$username" | sed -e 's/[[:space:]]//g') # supprime les ' '
    username=$(echo "$username" | sed -e 's/\r//g') # supprime les \n
    #username=echo "username | tr -d ' ' | tr -d '\n'"
    sudo useradd -m $username #-m pour créer dossier /hom auto
    #echo "$NAME $SURNAME $MAIL $PASSWORD"
done

