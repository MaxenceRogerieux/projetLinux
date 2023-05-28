#!/bin/bash

  #-------------------------------------------------------------#
  #----------------------  Notes  ------------------------------#
  #-------------------------------------------------------------#

# Pour lancer le script : sudo ./project.sh <adresse smtp> <login> <mdp>
# exemple : sudo ./project.sh smtp.office365.com:587 maxence.rogerieux@isen-ouest.yncrea.fr fakepasswd

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

if [ $choice == 1 ]
  then
  #----------------------  eclipse  ------------------------#
      rm -r eclipse

  #----------------------  sauvegarde  ---------------------#
      rm /home/retablir_sauvegarde.sh
fi

if [ $choice == 2 ]
  then
      # Instalation de Eclipse en local :
      wget "https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2023-03/R/eclipse-java-2023-03-R-linux-gtk-x86_64.tar.gz&r=1" -O eclipse.tar.gz

      tar -xzf eclipse.tar.gz
      rm -r eclipse.tar.gz


      rm /home/retablir_sauvegarde.sh
      touch /home/retablir_sauvegarde.sh

      #ecrire ligne par ligne le script dans le fichier
      echo "#!/bin/bash" >> /home/retablir_sauvegarde.sh
      echo "" >> /home/retablir_sauvegarde.sh
      echo "user=\$1" >> /home/retablir_sauvegarde.sh
      echo "" >> /home/retablir_sauvegarde.sh
      echo "# Variables SSH" >> /home/retablir_sauvegarde.sh
      echo "SSH_HOST=\"10.30.48.100\"" >> /home/retablir_sauvegarde.sh
      echo "SSH_USER=\"mroger25\"" >> /home/retablir_sauvegarde.sh
      echo "" >> /home/retablir_sauvegarde.sh
      echo "# Emplacement du fichier de sauvegarde" >> /home/retablir_sauvegarde.sh
      echo "BACKUP_FILE=\"/home/saves\"" >> /home/retablir_sauvegarde.sh
      echo "# Répertoire de sauvegarde" >> /home/retablir_sauvegarde.sh
      echo "BACKUP_DIR=\"\$SSH_USER@\$SSH_HOST:\$BACKUP_FILE\"" >> /home/retablir_sauvegarde.sh
      echo "# Emplacement du fichier de sauvegarde" >> /home/retablir_sauvegarde.sh
      echo "BACKUP_NAME=\"/home/\$user/a_sauver\"" >> /home/retablir_sauvegarde.sh
      echo "" >> /home/retablir_sauvegarde.sh
      echo "rm -r /home/\$user/a_sauver" >> /home/retablir_sauvegarde.sh
      echo "" >> /home/retablir_sauvegarde.sh
      echo "scp -i /home/isen/.ssh/id_rsa \$BACKUP_DIR \$BACKUP_NAME" >> /home/retablir_sauvegarde.sh


      # Activation de pare-feu
      apt install ufw -y
      ufw enable
      ufw deny ftp
      ufw deny proto udp from any to any

      # Nextcloud
      NXC_LOGIN="nextcloud-admin"
      NXC_PASSWD="N3x+ClOuD"

      # Installation de snapd et nextcloud
      # ssh -n -i /home/isen/.ssh/id_rsa $SSH_USER@$SSH_HOST "apt install snapd -y"
      # ssh -n -i /home/isen/.ssh/id_rsa $SSH_USER@$SSH_HOST "snap install core"
      # ssh -n -i /home/isen/.ssh/id_rsa $SSH_USER@$SSH_HOST "snap install nextcloud"
      
      # Configuration de nextcloud
      # ssh -n -i /home/isen/.ssh/id_rsa $SSH_USER@$SSH_HOST "/snap/bin/nextcloud.manual-install $NXC_LOGIN $NXC_PASSWD"

      #Tunnel du serveur nextcloud
      touch /home/tunnel_nextcloud
      chmod 755 /home/tunnel_nextcloud
      echo "#!/bin/bash" >> /home/tunnel_nextcloud
      echo "ssh -L 4242:$SSH_HOST:80 $SSH_USER@$SSH_HOST" >> /home/tunnel_nextcloud


      # Monitoring
      # ssh -n -i /home/isen/.ssh/id_rsa $SSH_USER@$SSH_HOST "wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh --nightly-channel --claim-token Dopn1McgKewN7ujssSf_S2DUuPznAndemJHJq8PYRIRGDrvOweT-GykC683plF7dRHYVacZREDopC7h895ehdqZOvzCW-hinZRCWNyXVYB8RAvRLmwX2JIOChEADDn7TsHRzkoA --claim-rooms 8584a810-d8f2-45de-aa16-deea77daec0a --claim-url https://app.netdata.cloud"

      #Tunnel du monitoring
      touch /home/tunnel_monitoring
      chmod 755 /home/tunnel_monitoring
      echo "#!/bin/bash" >> /home/tunnel_monitoring
      echo "ssh -L 19999:$SSH_HOST:19999 $SSH_USER@$SSH_HOST" >> /home/tunnel_monitoring
      
fi


#-------------------------------------------------------------#

# while read : execution a chaque ligne ; -r : text brut sans interpretation des \ par exemple
tail -n +2 accounts.csv | while IFS=';' read -r NAME SURNAME MAIL PASSWORD_RAW; do
    username=${NAME:0:1}$(echo "$SURNAME") # prend la premiere lettre du prenom et le nom
    username=$(echo "$username" | sed -e 's/[[:space:]]//g') # supprime les ' '
  
    # echo $username
    userList+=("$username")

    mdp=$(echo $PASSWORD_RAW | sed 's/\r$//' | sed 's/ $//') #supprime les retours à la ligne et espace dans le mot de passe
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
        
        echo -e "$mdp\n$mdp" | passwd "$username" #création du mdp
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
        if [ ! -f "/home/$username/eclipse" ]; 
        then
            ln -s eclipse/eclipse /home/$username/eclipse
        fi


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

        #-------------------------------------------------------------#
        #----------------------  Nextcloud  --------------------------#
        #-------------------------------------------------------------#
        export OC_PASS=$password
        /snap/bin/nextcloud.occ user:add --password-from-env --display-name="$NAME $SURNAME" $username

    fi
done



  #-------------------------------------------------------------#
  #----------------------  Fin  --------------------------------#
  #-------------------------------------------------------------#