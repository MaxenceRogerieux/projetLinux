#!/bin/bash

user=$1

# Variables SSH
SSH_HOST="10.30.48.100"
SSH_USER="mroger25"

# Emplacement du fichier de sauvegarde
BACKUP_FILE="/home/saves"
# Répertoire de sauvegarde
BACKUP_DIR="$SSH_USER@$SSH_HOST:$BACKUP_FILE"
# Emplacement du fichier de sauvegarde
BACKUP_NAME="/home/$user/a_sauver"

rm -r /home/$user/a_sauver

scp -i /home/isen/.ssh/id_rsa $BACKUP_DIR $BACKUP_NAME
