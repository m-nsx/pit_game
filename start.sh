#!/bin/bash

display_intro() {
    # Couleur par défaut
    RESET='\033[1;33m'
    NC='\033[0m' # No Color

    echo -e "${RESET}"
    cat << "EOF"

    █████  █████ ██████   █████ █████ █████ █████      █████████    █████████   ██████   ██████ ██████████
    ░░███  ░░███ ░░██████ ░░███ ░░███ ░░███ ░░███      ███░░░░░███  ███░░░░░███ ░░██████ ██████ ░░███░░░░░█
    ░███   ░███  ░███░███ ░███  ░███  ░░███ ███      ███     ░░░  ░███    ░███  ░███░█████░███  ░███  █ ░ 
    ░███   ░███  ░███░░███░███  ░███   ░░█████      ░███          ░███████████  ░███░░███ ░███  ░██████   
    ░███   ░███  ░███ ░░██████  ░███    ███░███     ░███    █████ ░███░░░░░███  ░███ ░░░  ░███  ░███░░█   
    ░███   ░███  ░███  ░░█████  ░███   ███ ░░███    ░░███  ░░███  ░███    ░███  ░███      ░███  ░███ ░   █
    ░░████████   █████  ░░█████ █████ █████ █████    ░░█████████  █████   █████ █████     █████ ██████████
    ░░░░░░░░   ░░░░░    ░░░░░ ░░░░░ ░░░░░ ░░░░░      ░░░░░░░░░  ░░░░░   ░░░░░ ░░░░░     ░░░░░ ░░░░░░░░░░ 

EOF
    echo -e "${NC}"
}

duration=900

# Réinitialise les permissions de tous les contenus
chmod 744 reset.sh
chmod 744 timer.sh
chmod 744 gameinit.sh
chmod 744 vault.sh
chmod 744 decipher.sh
chmod 744 verification.sh

# Vérifier si .time existe déjà avant de commencer
if [ -f "time" ]; then
    echo -e "\033[1;41;37mERREUR\033[0;31m Le jeu est déjà en cours !"
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
    echo -e "\033[1;42;37mSUCCÈS\033[0m \033[1;32mLe fichier a été chiffré avec succès !\033[0m"
else
    echo -e "\033[1;41;37mERREUR\033[0;31m Le chiffrement du fichier a échoué !"
    exit 1
fi

archive_name="archive.tar.gz"
tar -czf "$archive_name" key_file.enc
chmod 000 archive.tar.gz
rm -f key_file
rm -f key_file.enc

touch .temp
(date +%s) > .temp

echo ""

display_intro

# Lancer le script de compte à rebours en arrière-plan
if [ -f timer.sh ]; then
    ./timer.sh $duration &
    m=$(($duration / 60))
    s=$(($duration % 60))
    echo ""
    echo -e "\033[1;33mLe compte a rebours a été lancé ! Vous avez $m:$s pour terminer le jeu avant que \033[9;30mla bombe n'explose\033[0m \033[1;33mrm -rf !"
    echo -e "Vous pouvez à tout moment consulter le temps restant en effectuant 'cat time' à la racine."
    echo -e "Ou remettre le jeu à zéro en exécutant le script reset.sh avec './reset.sh'."
    echo ""
    echo -e "On ne voit bien qu'avec ls. L'essentiel est invisible sans paramètre."
    echo -e "\033[3;30mAntoine de Saint-Exupéry\033[0m"
    echo ""
    echo -e "\033[1;33mBonne chance !\033[0m"
    echo ""
else
    echo -e "\033[1;41;37mERREUR\033[0;31m Le script timer.sh n'existe pas !"
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
