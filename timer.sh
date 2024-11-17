#!/bin/bash

display_fail() {
    # Couleur rouge
    RED='\033[0;31m'
    NC='\033[0m' # No Color

    echo -e "${RED}"
    cat << "EOF"

    ███████╗ ██████╗██╗  ██╗███████╗ ██████╗
    ██╔════╝██╔════╝██║  ██║██╔════╝██╔════╝
    █████╗  ██║     ███████║█████╗  ██║     
    ██╔══╝  ██║     ██╔══██║██╔══╝  ██║     
    ███████╗╚██████╗██║  ██║███████╗╚██████╗
    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝

EOF
    echo -e "${NC}"
}

# Créer le fichier time si il n'existe pas déjà
if [ ! -f "time" ]; then
  touch time
else
  echo -e "\033[1;41;37mERREUR\033[0;31m Le fichier time exite déjà !"
  exit 1
fi

# Durée totale en secondes
DURATION="$1"

# Fichier où le temps restant sera affiché
TIME_FILE="time"

# Créer ou vider le fichier `time`
> "$TIME_FILE"

# Boucle pour décompter le temps
while [ "$DURATION" -gt 0 ]; do
  MINUTES=$((DURATION / 60))
  SECONDS=$((DURATION % 60))
  printf "%02d:%02d\n" "$MINUTES" "$SECONDS" > "$TIME_FILE"
  sleep 1
  DURATION=$((DURATION - 1))
done

# Temps écoulé !
echo ""
echo -e "\033[0;31mTemps écoulé !\033[0m"
echo "Temps écoulé !" > "$TIME_FILE"
display_fail
echo -e "\033[1;30mEffectuez ./reset.sh pour recommencer.\033[0m"