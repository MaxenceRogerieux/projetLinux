#!/bin/bash

#sudo ./project.sh smtp.office365.com:587 maxence.rogerieux@isen-ouest.yncrea.fr 1016AgRv

service cron start

# Récupération des paramettres
para_serv=$1
para_login=$2
para_mdp=$3

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

# Variables
#smtp://$usermail:$pass;auth=mech,...@host:$port;$params
file="accounts.csv"
Luser="mroger25"
Lpass="Isen44N"
usermail="maxence.rogerieux%40isen-ouest.yncrea.fr"
pass="1016AgRv"

smtpUrl="smtp://$usermail:$para_mdp;auth=LOGIN@smtp.office365.com:587"

#mail --subject "Test" --exec "set sendmail=$smtpUrl" --append "From:$usermail" $mail <<< "Hello World"

#mail --subject "Test" --exec "set sendmail=$smtpUrl" --append "From:$usermail" mael.grellier-neau@isen-ouest.yncrea.fr <<< "Hello World"

#mail --subject "Ceci est un test" --exec "set sendmail=smtp://mael.grellier-neau%40isen-ouest.yncrea.fr:68Mgn04N*;auth=LOGIN@smtp.office365.com:587" --append "From:mael.grellier-neau@isen-ouest.yncrea.fr" mael.grelneau@gmail.com <<< "<body>"

# Variables SSH
SSH_HOST="10.30.48.100"
SSH_USER="mroger25"
SSH_KEY="/home/$Luser/.ssh/id_rsa"
SMTP_COMMAND='mail --subject "Test" --exec "set sendmail=$smtpUrl" --append "From:$usermail" mael.grellier-neau@isen-ouest.yncrea.fr <<< "Hello World"'

# Commande fonctionnelle pour envoie mail
#ssh -i /home/mroger25/.ssh/id_rsa mroger25@10.30.48.100 'mail --subject "Test" --exec "set sendmail=smtp://maxence.rogerieux%40isen-ouest.yncrea.fr:1016AgRv;auth=LOGIN@smtp.office365.com:587" --append "From:maxence.rogerieux@isen-ouest.yncrea.fr" maxence.rogerieux@isen-ouest.yncrea.fr <<< "Hello World"'

#ssh -i $SSH_KEY $SSH_USER@$SSH_HOST "echo '$SMTP_COMMAND' | nc localhost 25"

# Instalation de Eclipse en local :
  #wget "https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2023-03/R/eclipse-java-2023-03-R-linux-gtk-x86_64.tar.gz&r=1" -O eclipse.tar.gz

  #tar -xzf eclipse.tar.gz

# while read : execution a chaque ligne ; -r : text brut sans interpretation des \ par exemple
tail -n +2 accounts.csv | while IFS=';' read -r NAME SURNAME MAIL PASSWORD; do
    username=${NAME:0:1}$(echo "$SURNAME") # prend la premiere lettre du prenom et le nom
    username=$(echo "$username" | sed -e 's/[[:space:]]//g') # supprime les ' '
    
    # echo $username
    userList+=("$username")

    mdp=${PASSWORD::-2} #supprime les \n
    # echo $mdp

    if [ $choice == 1 ]
    then
        userdel -r -f $username
    fi

    if [ $choice == 2 ]
    then
        #-------------------------------------------------------------#
        #----------------------  Création du compte  -----------------#
        #-------------------------------------------------------------#

        useradd -m $username #-m pour créer dossier /home auto
        
        echo -e "${PASSWORD::-2}\n${PASSWORD::-2}" | passwd "$username" #création du mdp
        chage -d 0 $username #expiration du mdp à la première connexion

        #-------------------------------------------------------------#
        #----------------------  Mail  -------------------------------#
        #-------------------------------------------------------------#

        login=$(echo "$para_login" | sed -e 's/@/%40/g') # remplace @ par %40 pour le mail

        # mail
        ssh -n -i /home/isen/.ssh/id_rsa mroger25@10.30.48.100 "mail --subject \"Premiere connexion aux services\" --exec \"set sendmail=smtp://$login:$para_mdp;auth=LOGIN@$para_serv\" --append \"From:$para_login\" $para_login <<< \"
        Bonjour $NAME $SURNAME,

        Voici vos identifiants pour vous connecter à votre compte :
        
        Login : $username
        Mot de passe : $mdp

        Vous devrez changer votre mot de passe à la première connexion.

        Cordialement,

        L'équipe informatique de l'ISEN Yncréa Ouest
        \""

        # parametres d'entrée :
        #$para_serv=smtp.office365.com:587
        #$para_login=maxence.rogerieux@isen-ouest.yncrea.fr
        #$para_mdp=1016AgRv

        #-------------------------------------------------------------#
        #----------------------  Eclipse  ----------------------------#
        #-------------------------------------------------------------#
        
        #lien symbolique vers eclipse pour chaque user
        ln -s eclipse /home/$username/eclipse
        
        #-------------------------------------------------------------#
        #----------------------  Sauvegarde  -------------------------#
        #-------------------------------------------------------------#

        # mkdir /home/$username/a_sauver #création d'un dossier a_sauver par user

        # Définir le répertoire à sauvegarder
        BACKUP_DIR="/home/$username/a_sauver"

        # Nom et l'emplacement du fichier de sauvegarde
        BACKUP_FILE="$SSH_USER@$SSH_HOST:/home/saves/save_$username.tgz"

        #(crontab -l && echo "* * * * 1-5 echo 'hello'") | crontab -
        #0 23 * * 1-5

        cmd="touch /home/bjr.txt"
        #cmd="echo hello world"

        #CronCommand="ssh -i $SSH_KEY $SSH_USER@$SSH_HOST "tar -czvf - $BACKUP_DIR" > $BACKUP_FILE"

        #crontab -r
        #crontab -l > mycron
        #echo new cron into cron file
        #echo "* * * * * $cmd" >> mycron
        #crontab mycron
        #rm mycron
    fi
done

#0 23 * * 1-5
#crontab -l > mycron
#echo "* * * * * $CronCommand" >> mycron
#crontab mycron
#rm mycron

#alias projet="cd /mnt/c/Users/maxou/'OneDrive - yncréa'/Documents/ISEN/'CIR 3'/'Admin Linux'/projetLinux/"