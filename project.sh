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

#Variables
#smtp://$usermail:$pass;auth=mech,...@host:$port;$params
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
ssh -i /home/mroger25/.ssh/id_rsa $SSH_USER@$SSH_HOST 'mail --subject "Test" --exec "set sendmail=smtp://maxence.rogerieux%40isen-ouest.yncrea.fr:1016AgRv;auth=LOGIN@smtp.office365.com:587" --append "From:maxence.rogerieux@isen-ouest.yncrea.fr" maxence.rogerieux@isen-ouest.yncrea.fr <<< "Hello World"'

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

    mdp=${PASSWORD::-2}  # supprime les \n
    
    #echo $mdp

    sudo useradd -m $username #-m pour créer dossier /hom auto
    
    echo -e "${PASSWORD::-2}\n${PASSWORD::-2}" | passwd "$username" #création du mdp
    sudo chage -d 0 $username #expiration du mdp

    mkdir /home/$username/a_sauver #création d'un dossier a_sauver par user

    mail --subject "<subject>" --exec "set sendmail=<smtp-url>" --append "From:<sender-email>" <reciever-email> <<< "<body>"

    
done

#Sauvergarde