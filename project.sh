#!/bin/bash

  #-------------------------------------------------------------#
  #----------------------  Notes  ------------------------------#
  #-------------------------------------------------------------#

#sudo ./project.sh smtp.office365.com:587 maxence.rogerieux@isen-ouest.yncrea.fr 1016AgRv

#alias projet="cd /mnt/c/Users/maxou/'OneDrive - yncréa'/Documents/ISEN/'CIR 3'/'Admin Linux'/projetLinux/"

  #-------------------------------------------------------------#
  #----------------------  Script  -----------------------------#
  #-------------------------------------------------------------#
  
service cron start
crontab -r

  #-------------------------------------------------------------#
  #----------------------  Variables  --------------------------#
  #-------------------------------------------------------------#

# Récupération des paramettres
para_serv=$1
para_login=$2
para_mdp=$3

# Variables SSH
SSH_HOST="10.30.48.100"
SSH_USER="mroger25"

SSH_KEY="/home/$Luser/.ssh/id_rsa"
SMTP_COMMAND='mail --subject "Test" --exec "set sendmail=$smtpUrl" --append "From:$usermail" mael.grellier-neau@isen-ouest.yncrea.fr <<< "Hello World"'

  #-------------------------------------------------------------#
  #----------------------  Menu  -------------------------------#
  #-------------------------------------------------------------#

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
 
  #-------------------------------------------------------------#

# while read : execution a chaque ligne ; -r : text brut sans interpretation des \ par exemple
tail -n +2 accounts.csv | while IFS=';' read -r NAME SURNAME MAIL PASSWORD; do
    username=${NAME:0:1}$(echo "$SURNAME") # prend la premiere lettre du prenom et le nom
    username=$(echo "$username" | sed -e 's/[[:space:]]//g') # supprime les ' '
    
    # echo $username
    userList+=("$username")

    mdp=${PASSWORD::-2} #supprime les \n
    # echo $mdp

    #filtrer les \n

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

        #ssh -n -i /home/isen/.ssh/id_rsa $SSH_USER@$SSH_HOST "mail --subject \"Premiere connexion aux services\" --exec \"set sendmail=smtp://$login:$para_mdp;auth=LOGIN@$para_serv\" --append \"From:$para_login\" $MAIL <<< \"
        # Bonjour $NAME $SURNAME,

        # Voici vos identifiants pour vous connecter à votre compte :
        
        # Login : $username
        # Mot de passe : $mdp

        # Vous devrez changer votre mot de passe à la première connexion.

        # Cordialement,

        # L'équipe informatique de l'ISEN Yncréa Ouest
        # \""

        #-------------------------------------------------------------#
        #----------------------  Eclipse  ----------------------------#
        #-------------------------------------------------------------#
        
        #lien symbolique vers eclipse pour chaque user
        ln -s eclipse /home/$username/eclipse
        
        #-------------------------------------------------------------#
        #----------------------  Sauvegarde  -------------------------#
        #-------------------------------------------------------------#

        mkdir /home/$username/a_sauver #création d'un dossier a_sauver par user

        # Répertoire à sauvegarder
        BACKUP_DIR="/home/$username/a_sauver"
        BACKUP_NAME="save_$username.tgz"
        # Emplacement du fichier de sauvegarde
        BACKUP_FILE="/home/saves"

        #-------------------------------------------------------------#
        
        crontab -l > mycron
        echo "new cron into cron file"

        echo "0 23 * * 1-5 tar -czvf $BACKUP_NAME $BACKUP_DIR && scp -i /home/isen/.ssh/id_rsa $BACKUP_NAME $SSH_USER@$SSH_HOST:$BACKUP_FILE && rm $BACKUP_NAME" >> mycron
        echo "" >> mycron

        crontab mycron
        rm mycron
    fi
done

if [ $choice == 1 ]
  then
  #----------------------  eclipse  ------------------------#
      rm -r eclipse

  #----------------------  sauvegarde  ---------------------#
      rm retablir_sauvegarde.sh
fi

if [ $choice == 2 ]
  then
#       # Instalation de Eclipse en local :
        
#       wget "https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2023-03/R/eclipse-java-2023-03-R-linux-gtk-x86_64.tar.gz&r=1" -O eclipse.tar.gz

#       tar -xzf eclipse.tar.gz
#       rm -r eclipse.tar.gz


        rm retablir_sauvegarde.sh
        touch retablir_sauvegarde.sh

        #ecrire ligne par ligne le script dans le fichier
        echo "#!/bin/bash" >> retablir_sauvegarde.sh
        echo "" >> retablir_sauvegarde.sh
        echo "user=\$1" >> retablir_sauvegarde.sh
        echo "" >> retablir_sauvegarde.sh
        echo "# Variables SSH" >> retablir_sauvegarde.sh
        echo "SSH_HOST=\"10.30.48.100\"" >> retablir_sauvegarde.sh
        echo "SSH_USER=\"mroger25\"" >> retablir_sauvegarde.sh
        echo "" >> retablir_sauvegarde.sh
        echo "# Emplacement du fichier de sauvegarde" >> retablir_sauvegarde.sh
        echo "BACKUP_FILE=\"/home/saves\"" >> retablir_sauvegarde.sh
        echo "# Répertoire de sauvegarde" >> retablir_sauvegarde.sh
        echo "BACKUP_DIR=\"\$SSH_USER@\$SSH_HOST:\$BACKUP_FILE\"" >> retablir_sauvegarde.sh
        echo "# Emplacement du fichier de sauvegarde" >> retablir_sauvegarde.sh
        echo "BACKUP_NAME=\"/home/\$user/a_sauver\"" >> retablir_sauvegarde.sh
        echo "" >> retablir_sauvegarde.sh
        echo "rm -r /home/\$user/a_sauver" >> retablir_sauvegarde.sh
        echo "" >> retablir_sauvegarde.sh
        echo "scp -i /home/isen/.ssh/id_rsa \$BACKUP_DIR \$BACKUP_NAME" >> retablir_sauvegarde.sh


        # Activation de pare-feu
        apt install ufw -y
        ufw enable
        ufw deny ftp
        ufw deny proto udp from any to any

        # Nextcloud
        apt install snapd -y
        apt install core
        snap install nextcloud

        #

fi

  #-------------------------------------------------------------#
  #----------------------  Fin  --------------------------------#
  #-------------------------------------------------------------#