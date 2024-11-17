#!/bin/bash

duration=900

# Réinitialise les permissions de tous les contenus
chmod 744 reset.sh
chmod 744 timer.sh
chmod 744 gameinit.sh
chmod 744 vault.sh
chmod 744 decipher.sh
chmod 744 verification.sh
chmod 744 virus.sh

# Vérifier si .time existe déjà avant de commencer
if [ -f "time" ]; then
    echo "ERREUR : Le jeu est déjà en cours !"
    exit 1
fi

# Remise a zéro du jeu
./reset.sh

# Initialisation du jeu
./gameinit.sh

# Générer le fichier .hint
hint_file=".hint"
hint_text="Le mot de passe se trouve dans un des 1250 fichiers générés !
Pour information il se trouve à la suite de la chaîne de caractères 'mdp='
Bonne exploration dans les dossiers !"
echo "$hint_text" > "$hint_file"

#  Générer l'archive sans permissions contenant le fichier chiffré
touch key_file

key_text="Pour terminer le mini jeu il vous faudra :
1. Creer un fichier 'defuse'
 | 2. Creer un dossier 'main'
 | 3. Deplacer le fichier 'defuse' dans le dossier precedemment cree
 | 4. Ecrire la phrase 'I... am Steve' dans le fichier 'defuse'
 | 5. Valider votre solution a l'aide du script 'verification.sh'.
 Si vous avez correctement realise toutes les etapes vous gagnez le mini jeu !"
echo "$key_text" > "key_file"

shift_key=3
key_file="key_file"
encrypted_file="key_file.enc"
encrypt() {
  local input_file="$1"
  local output_file="$2"
  local shift="$3"
  while IFS= read -r -n1 char; do
    ascii=$(printf "%d" "'$char")
    if [[ "$ascii" -ge 65 && "$ascii" -le 90 ]]; then
      new_ascii=$(( (ascii - 65 + shift) % 26 + 65 ))
    elif [[ "$ascii" -ge 97 && "$ascii" -le 122 ]]; then
      new_ascii=$(( (ascii - 97 + shift) % 26 + 97 ))
    elif [[ "$ascii" -ge 48 && "$ascii" -le 57 ]]; then
      new_ascii=$(( (ascii - 48 + shift) % 10 + 48 ))
    else
      new_ascii=$ascii
    fi
    printf "\\$(printf '%03o' "$new_ascii")" >> "$output_file"
  done < "$input_file"
}
encrypt "$key_file" "$encrypted_file" "$shift_key"
if [ $? -eq 0 ]; then
    echo "Le fichier a été chiffré avec succès !"
else
    echo "ERREUR : Le chiffrement du fichier a échoué !"
    exit 1
fi

archive_name="archive.tar.gz"
tar -czf "$archive_name" key_file.enc
chmod 000 archive.tar.gz
rm -f key_file
rm -f key_file.enc

# Lancer le script de compte à rebours en arrière-plan
if [ -f timer.sh ]; then
    ./timer.sh $duration &
    m=$(($duration / 60))
    s=$(($duration % 60))
    echo ""
    echo "Le compte a rebours a été lancé ! Vous avez $m:$s pour terminer le jeu avant que la bombe n'explose !"
    echo "Vous pouvez à tout moment consulter le temps restant en effectuant "cat time" à la racine."
    echo "Ou remettre le jeu à zéro en executant le script reset.sh avec ./reset.sh."
    echo ""
    echo "On ne voit bien qu'avec ls. L'essentiel est invisible sans paramètre."
    echo "Antoine de Saint-Exupéry"
    echo ""
    echo "Bonne chance !"
else
    echo "ERREUR : Le script timer.sh n'existe pas !"
fi

exit 0






















































      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢉⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡅⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠄⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⣉⣁⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣈⡏⠹⡟⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣦⡀⠀⠈⣿⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠛⠃⣰⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⠘⣿⣤⡀⢀⡀⠀⠀⠉⠻⡟⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⢉⣁⣡⣤⣴⡾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣾⣹⣿⣾⢿⣆⣠⠀⠀⢁⠈⣿⡿⠀⠈⣿⠟⠀⠈⠹⣿⡏⠀⠀⠈⣿⡟⠁⠸⣿⠃⣼⣏⢀⡆⣴⣿⣿⡟⡅⣿⢱⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣹⣿⡿⢿⣶⣷⣼⣷⣟⠁⠀⠀⡟⠀⠀⠀⠀⣽⡇⠀⠀⠀⠨⠄⠀⠀⢙⡀⢃⣸⣾⣿⣼⣿⢸⣧⣷⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣿⣷⡈⣷⡈⣻⣿⣼⣦⣀⣰⠃⠀⠀⠀⠀⠙⠁⠀⡀⠀⠊⣠⣀⣤⣾⣷⡌⣯⣿⢟⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡺⠇⢹⣿⣿⣿⡿⣿⣤⣀⣀⣤⣤⣴⣄⠀⠃⣄⣀⢿⡿⠛⠿⣿⠙⣿⣷⣼⣧⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣾⠹⣿⡿⠁⢹⡃⠈⠉⣿⠁⠊⡿⠀⠈⣿⠀⢸⡇⠀⠀⢿⡄⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣿⠁⣠⣾⠇⠀⢠⣧⠀⢠⡇⠀⢀⣿⡀⢸⣇⠀⢠⣸⣷⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⣿⣦⣠⣾⣿⣶⣾⣷⣤⣸⣿⣿⣾⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿

####################################################################################################
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
#                           VOUS N'ÊTES PAS AUTORISÉ À LIRE CE FICHIER                             #
#               si vous avez fait "cat start.sh" revenez immédiatement en arrière                  #
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
#                                                                                                  #
####################################################################################################
