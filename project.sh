#!/bin/bash

select="Choisissez une option : " # définit le prompt pour select
options=("Delete previous users" "Create users") # liste des options

select choix in "${options[@]}"
do
  case $choix in
    "Delete previous users")
      echo "Vous avez choisi 'Delete previous users'"
      choice=1
      break
      ;;
    "Create users")
      echo "Vous avez choisi 'Create users'"
      choice=2
      break
      ;;
    "Quitter")
      break # quitte la boucle select et termine le script
      ;;
    *)
      echo "Option invalide"
      ;;
  esac
done


#Variables
#smtp://$usermail:$pass;auth=mech,...@host:$port;$params

#declare -a userList=()
file="accounts.csv"
Luser="mroger25"
Lpass="Isen44N"
usermail="maxence.rogerieux%40isen-ouest.yncrea.fr"
pass="1016AgRv"
smtpUrl="smtp://$usermail:$pass;auth=LOGIN@smtp.office365.com:587"

#mail --subject "Test" --exec "set sendmail=$smtpUrl" --append "From:$usermail" $mail <<< "Hello World"

#mail --subject "Test" --exec "set sendmail=$smtpUrl" --append "From:$usermail" mael.grellier-neau@isen-ouest.yncrea.fr <<< "Hello World"

#mail --subject "Ceci est un test" --exec "set sendmail=smtp://mael.grellier-neau%40isen-ouest.yncrea.fr:68Mgn04N*;auth=LOGIN@smtp.office365.com:587" --append "From:mael.grellier-neau@isen-ouest.yncrea.fr" mael.grelneau@gmail.com <<< "<body>"

#Variables SSH
SSH_HOST="10.30.48.100"
SSH_USER="mroger25"
SSH_KEY="/home/$Luser/.ssh/id_rsa"
SMTP_COMMAND='mail --subject "Test" --exec "set sendmail=$smtpUrl" --append "From:$usermail" mael.grellier-neau@isen-ouest.yncrea.fr <<< "Hello World"'

# Commande fonctionnelle pour envoie mail
#ssh -i /home/mroger25/.ssh/id_rsa mroger25@10.30.48.100 'mail --subject "Test" --exec "set sendmail=smtp://maxence.rogerieux%40isen-ouest.yncrea.fr:1016AgRv;auth=LOGIN@smtp.office365.com:587" --append "From:maxence.rogerieux@isen-ouest.yncrea.fr" maxence.rogerieux@isen-ouest.yncrea.fr <<< "Hello World"'

#ssh -i $SSH_KEY $SSH_USER@$SSH_HOST "echo '$SMTP_COMMAND' | nc localhost 25"

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
    userList+=("$username")

    mdp=${PASSWORD::-2} #supprime les \n
    #echo $mdp

    if [ $choice == 1 ]
    then
        userdel -r -f $username
    fi

    if [ $choice == 2 ]
    then

        useradd -m $username #-m pour créer dossier /hom auto
        
        echo -e "${PASSWORD::-2}\n${PASSWORD::-2}" | passwd "$username" #création du mdp
        chage -d 0 $username #expiration du mdp

        #mkdir /home/$username/a_sauver #création d'un dossier a_sauver par user

        #mail --subject "<subject>" --exec "set sendmail=<smtp-url>" --append "From:<sender-email>" <reciever-email> <<< "<body>"
    fi
    
    
done

#read -ap $userList
#Sauvergarde
for users in "${userList[*]}"
do
    echo $users
done

for (( i=0; i < ${#tab[*]}; i++ )); do
    echo ${tab[i]}
done


#for users in userList
#do
    #Répertoire à sauvegarder
    #BACKUP_DIR="/home/$users/a_sauver"

    #Nom et l'emplacement du fichier de sauvegarde
    #BACKUP_FILE="$SSH_USER@$SSH_HOST:/home/saves/save_$username.tgz"



    #ssh -i $SSH_KEY $SSH_USER@$SSH_HOST "tar -czvf - $BACKUP_DIR" > $BACKUP_FILE
#done