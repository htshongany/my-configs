#!/bin/bash

# Détecter l'utilisateur connecté, même en cas de sudo ou su
if [ "$SUDO_USER" ]; then
  TARGET_USER="$SUDO_USER"
  TARGET_HOME="/home/$SUDO_USER"
else
  TARGET_USER="$USER"
  TARGET_HOME="$HOME"
fi

# Chemin du fichier et fichier log
CONF_FILE="$TARGET_HOME/.git-prompt.sh"
LOGFILE="/var/log/check_git_prompt.log"
REPO_URL="https://github.com/htshongany/my-configs/blob/main/windows/.git-prompt.sh"

# Vérifier si le fichier existe
if [ ! -f "$CONF_FILE" ]; then
  echo "$(date): $CONF_FILE is missing. Downloading the file." >> $LOGFILE

  # Télécharger le fichier avec curl
  sudo -u "$TARGET_USER" curl -o "$CONF_FILE" "$REPO_URL" >> $LOGFILE 2>&1
  
  # Vérifier si le téléchargement a réussi
  if [ $? -eq 0 ]; then
    echo "$(date): $CONF_FILE downloaded successfully." >> $LOGFILE
  else
    echo "$(date): Failed to download $CONF_FILE." >> $LOGFILE
  fi
else
  echo "$(date): $CONF_FILE already exists." >> $LOGFILE
fi