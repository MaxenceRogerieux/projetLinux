#!/bin/bash

# Définir la liste des utilisateurs à supprimer
sudo userdel -r -f EWeatherwax
sudo userdel -r -f GOgg
sudo userdel -r -f ANitt
sudo userdel -r -f TAching
sudo userdel -r -f MStoHelit
sudo userdel -r -f YStoHelit
sudo userdel -r -f SStoHelit
sudo userdel -r -f HVetinari
sudo userdel -r -f LofQuirm
sudo userdel -r -f SVimes
sudo userdel -r -f CIronfoundersson
sudo userdel -r -f AvonUberwald
sudo userdel -r -f FColon
sudo userdel -r -f NNobbs
sudo userdel -r -f MRidcullus
sudo userdel -r -f PStibbons
sudo userdel -r -f SRamkin

#awf (data file parsing) : -F -> field separator ; NR>1 : row>1 ; $1 : column 1

#awk -F ';' 'NR>1 {print $1}' "accounts.csv" > names.txt
#awk -F ';' 'NR>1 {print $2}' "accounts.csv" > surnames.txt
#awk -F ';' 'NR>1 {print $3}' "accounts.csv" > mails.txt
#awk -F ';' 'NR>1 {print $4}' "accounts.csv" > passwords.txt

#while read : execution a chaque ligne ; -r : text brut sans interpretation des \ par exemple
tail -n +2 accounts.csv | while IFS=';' read -r NAME SURNAME MAIL PASSWORD; do
    username=${NAME:0:1}$(echo "$SURNAME") # prend la premiere lettre du prenom et le nom
    username=$(echo "$username" | sed -e 's/[[:space:]]//g') # supprime les ' '
    
    #echo $username

    mdp=${PASSWORD::-2}  # supprime les \n
    
    echo $mdp

    sudo useradd -m $username #-m pour créer dossier /hom auto
    
    echo -e "${PASSWORD::-2}\n${PASSWORD::-2}" | passwd "$username"

done

#sudo useradd -m EWeatherwax
#echo -e "{S7?U-4}FF\n{S7?U-4}FF" | passwd $username