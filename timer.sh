#!/bin/bash

# Créer le fichier time si il n'existe pas déjà
if [ ! -f "time" ]; then
    touch time
else
    echo "ERREUR : Le fichier time exite déjà !"
    exit 1
fi

# Durée totale en secondes
DURATION=3000

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
echo "Temps écoulé !" > "$TIME_FILE"
echo "Temps écoulé !"
