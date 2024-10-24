#!/bin/bash

# Fonction pour générer un mot de passe aléatoire
generer_mot_de_passe() {
    echo $(openssl rand -base64 10)
}

# Fonction pour ajouter un nouvel utilisateur
ajouter_utilisateur() {
    local nom_utilisateur="$1"
    local groupe="$2"
    local shell="$3"
    local repertoire="$4"

    echo "Ajout du nouvel utilisateur : $nom_utilisateur"
    getent group "$groupe" >/dev/null || groupadd "$groupe"

    useradd -m -d "$repertoire" -s "$shell" -g "$groupe" "$nom_utilisateur"

    mot_de_passe=$(generer_mot_de_passe)
    echo "$nom_utilisateur:$mot_de_passe" | chpasswd

    # Expiration mdp
    chage -d 0 "$nom_utilisateur"

    # Afficher les informations de l'utilisateur
    echo "Utilisateur $nom_utilisateur ajouté avec succès."
    echo "Mot de passe crée pour $nom_utilisateur : $mot_de_passe"
    echo "Le mot de passe expirera à la prochaine connexion."
}


if [ -z "$1" ]; then
    echo "Usage : $0 fichier_utilisateurs.txt"
    exit 1
fi


