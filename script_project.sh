#!/bin/bash 

#faire un menu pour chaque fonctionalité 
#les fonctionalités à ajouter : 
#ajouter et modifier un utilisateur 
#supprésion et gestion des utilisateur inactifs
#gestion des groupe 
#gestion des permission avec acl

Add_user(){
    ..
}

delete_user(){
    ..
}

update_user(){
    ..
}

see_user(){
    ..
}

add_group(){
    ..
}

remove_user_from_group(){
    ..
}

delete_empty_group(){
    ..
}

set_acl(){
    ..
}

set_default_acl(){
    ..
}

get_acl(){
    ..
}

menu_permission(){
    while true; do
        echo "1. Attribuer des permission sur un groupe"
        echo "2. Appliquer des permission par défault sur un répertoire ou fichier"
        echo "3. Voir les permission d'un répertoire"
        echo "4. Retour" 
        read -p "Choisissez une option:" choice_menu_acl
        clear

        case $choice_menu_acl in

        1) set_acl
        ;;

        2) set_default_acl
        ;;

        3) get_acl
        ;;

        4) break
        ;;

        *) echo "Choix invalide"
        ;;
        
        esac
    done

}

menu_group(){
    while true; do 
        echo "1. Crée un groupe"
        echo "2. retirer un utilisateur d'un groupe"
        echo "3. suprimer un groupe vide"
        echo "4. retour"
        read -p "Choisissez une option:" choice_menu_group
        clear
        
        case $choice_menu_group in 

        1)add_group
        ;;

        2)remove_user_from_group
        ;;

        3)delete_empty_group
        ;;

        4)break
        ;;

        *)echo "Choix invalide"
        ;;

        esac
    done
}

menu_user(){
    while true; do
        echo "1. Ajouter un utilisateur"
        echo "2. Supprimé un utilisateur"
        echo "3. Modifier un utilisateur"
        echo "4. Voir tous les utilisateurs"
        echo "5. Retour"
        read -p "Choisissez une option:" choice_menu_user
        clear

        case $choice_menu_user in

        1)Add_user
        ;;

        2)delete_user
        ;;

        3)update_user
        ;;

        4)see_user
        ;;

        5)break
        ;;

        *)echo "Choix invalide"
        ;;
        
        esac
    done

}


while true; do
    echo "1. Ajouter, modifier ou supprimer un utilisateur"
    echo "2. Gestion des groupes"
    echo "3. Attribuer des permissions"
    echo "4. Voir les utilisateur inactif"
    read -p "Choisissez une options :" user_input
    clear

    case $user_input in

        1)menu_user
        ;;

        2)menu_group
        ;;

        3)fontiocn
        ;;

        4)fontiocn
        ;;

        *)echo "Choix invalide"
        ;;

    esac
done