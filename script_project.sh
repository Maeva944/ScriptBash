#!/bin/bash 

#faire un menu pour chaque fonctionalité 
#les fonctionalités à ajouter : 
#ajouter et modifier un utilisateur 
#supprésion et gestion des utilisateur inactifs
#gestion des groupe 
#gestion des permission avec acl

Add_user(){
    echo "Vous allez crée un utilisateur :"
    read -p "Quel est le nom de l'utilisateur ?:" name_user
    read -p "Dans quel groupe appartiendra t'il?:" group_user
    if [[ -n $name_user ]]; then
        sudo useradd -m $name_user
    if [[ -n $group_user && -n $name_user ]]; then
        sudo useradd -g $group_user -m $name_user
    fi
    else 
        echo "Le champs est vide"
    fi
}

#delete_user(){
#    echo "Vous allez supprimer un utilisateur :"
#    read -p "Quel est le nom de l'utilisateur ?:" name_user
#    if [[ -n $name_user ]]; then
#        sudo userdel -r -f  $name_user
#    else 
#        echo "Le champs est vide"
#    fi
#}

delete_user() {
    echo "Vous allez supprimer un utilisateur :"
    read -p "Quel est le nom de l'utilisateur ? : " name_user

    if [[ -n $name_user ]]; then
        # Vérifie si l'utilisateur est actif
        if pgrep -u "$name_user" > /dev/null; then
            sudo pkill -u $name_user

            sleep 2 

            sudo userdel -r -f "$name_user"
            if [[ $? -eq 0 ]]; then
                echo "L'utilisateur $name_user a été supprimé avec succès."
            else
                echo "Erreur lors de la suppression de l'utilisateur $name_user."
            fi
        fi 
    else 
        echo "Le champ est vide."
    fi
}

update_name(){
    echo "Vous allez changer le nom d'un user"
    read -p "Le nom actuelle de l'utilisateur" past_name
    read -p "Nouveau nom de l'utilisateur" new_name
    if [[ -n $past_name && -n $new_name ]]; then 
        sudo usermod -l $new_name $past_name
    else 
        echo "Le champs est vide"
    fi
}


update_group(){
    read -p "Quel est le nom de l'user ?: " name_user
    read -p "Quel est le nom du groupe ?: " group_user 
    if [[ -n name_user && -n $group_user ]]; then 
        sudo usermod -g $group_user $name_user
    else 
        echo "Le champs est vide"
    fi 
}

update_pswd(){
    read -p "Quel est le nom de l'utilisateur dont vous souhaitez changer le mot de passe ?:" user_name

    random_pswd=$(openssl rand -base64 10)

    if [[ -n $user_name ]]; then 
        echo "$user_name:$random_pswd" | sudo chpasswd
        if [[ $? -eq 0 ]]; then
            sudo chage -M 2 $user_name
            echo "Le mot de passe pour $user_name est : $random_pswd"
        else 
            echo "Erreur : le mot de passe de $user_name n'a pas pue être modifier"
        fi
    else 
        echo "Le champs est vide"
    fi
}

secondary_group(){
    read -p "Quel est le nom de l'user ?: " name_user
    read -p "Quel est le nom du groupe ?: " group_user 
    if [[ -n name_user && -n $group_user ]]; then 
        sudo usermod -aG $group_user $name_user
    else 
        echo "Le champs est vide"
    fi 
}


see_user(){
    echo "Voici la liste de tous les utilisateur :"
    cat /etc/passwd
}

add_group(){
    read -p "Quel est le nom de ce nouveau groupe ?:" groupe_name
    if [[ -n $groupe_name ]]; then 
        echo "Le groupe $groupe_name à été ajouté"
        sudo groupadd $groupe_name
    else 
        echo "Le champs est vide"
    fi
}

remove_user_from_group(){
    echo "Vous allez retirer un user d'un groupe"
    read -p "Quel est le nom de l'user ?: " user_name
    read -p "Quel est le nom du groupe ?: " group_name
    if [[ -n $user_name && -n $group_name ]]; then 
        sudo deluser $user_name $group_name
    else 
        echo "Le champs est vide"
    fi
}

delete_empty_group() {
    read -p "Quel est le nom du groupe à supprimer ?:" group_name
    members=$(getent group "$group_name" | cut -d: -f4)

    if [ -z "$members" ]; then
        sudo groupdel "$group_name"
        echo "Le groupe $group_name a été supprimé."
    else
        echo "Le groupe n'est pas vide, il ne peut donc pas être supprimé."
    fi
}


see_group(){
    echo "Voici la liste de tous les groupes :"
    getent group
}

set_acl_read(){  
    read -p "Sur quel groupe voulez vous accorder des permissions ?:" acl_group
    read -p "Sur quel repertoire ou fichier ?:" fichier_doss

    if [[ -n $acl_group && -n $fichier_doss ]]; then
        echo "Les permissions on bien été mis à jours"
        setfacl -m g:$acl_group:r $fichier_doss
    else 
        echo "Le champs est vide"
    fi
}

set_acl_write(){  
    read -p "Sur quel groupe voulez vous accorder des permissions ?:" acl_group
    read -p "Sur quel repertoire ou fichier ?:" fichier_doss

    if [[ -n $acl_group && -n $fichier_doss ]]; then
        echo "Les permissions on bien été mis à jours"
        setfacl -m g:$acl_group:w $fichier_doss
    else 
        echo "Le champs est vide"
    fi
}

set_acl_excute(){  
    read -p "Sur quel groupe voulez vous accorder des permissions ?:" acl_group
    read -p "Sur quel repertoire ou fichier ?:" fichier_doss

    if [[ -n $acl_group && -n $fichier_doss ]]; then
        echo "Les permissions on bien été mis à jours"
        setfacl -m g:$acl_group:X $fichier_doss
    else 
        echo "Le champs est vide"
    fi
}


get_acl(){
    read -p "Quel est le repertoire ou fichier dont vous voulez voir les permissions ?:" fichier_doss
    if [[ -n $fichier_doss ]]; then
        echo "Voici les permissions :"
        getfacl -a $fichier_doss
    else 
        echo "le champs est vide"
    fi
}

menu_update_group(){
    while true; do
    echo "Que vous voulez vous ?: "
    echo "1. Changer le groupe principal"
    echo "2. Ajouter ou changer un groupe supplémentaire"
    echo "3. Retour"
    read -p "Choisissez une option :" user_input2
    clear
        case $user_input2 in 

            1)update_group 
            ;;

            2)secondary_group 
            ;;

            3)break
            ;;

            *)echo "Choix invalide"
            ;;
            esac
    done
}

update_user(){
    while true; do
    echo "Que vous voulez vous modifier ?"
    echo "1. Le nom de l'utilisateur ?"
    echo "2. Le groupe de l'utilisateur ?"
    echo "3. Le répertoire ?"
    echo "4. Le mot de passe ?"
    echo "5. Retour"
    read -p "Choisissez une option" user_input3
    clear
        case $user_input3 in

            1)update_name
            ;;

            2)menu_update_group
            ;;

            3)..
            ;;

            4)update_pswd
            ;;

            5)break
            ;;

            *)echo "Choix invalide"
            ;;
        esac
    done
}

sous_menu_permission(){
    while true; do 
        echo "Quel sont les permission que vous voulez ajouter ?"
        echo "1. lire"
        echo "2. écrire"
        echo "3. executer"
        echo "4. retour"
        read -p "Choisisez une option" choice_sous_menu
        clear

        case $choice_sous_menu in

            1)set_acl_read
            ;;

            2)set_acl_write
            ;;

            3)set_acl_excute
            ;;

            4)break
            ;;

            *) echo "Choix invalide"
            ;;
        esac
    done


}

menu_permission(){
    while true; do
        echo "1. Attribuer des permission sur un groupe"
        # echo "2. Appliquer des permission par défault sur un répertoire ou fichier"
        echo "3. Voir les permission d'un répertoire"
        echo "4. Retour" 
        read -p "Choisissez une option:" choice_menu_acl
        clear

        case $choice_menu_acl in

        1) sous_menu_permission
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
        echo "4. Voir tous les groupes"
        echo "5. retour"
        read -p "Choisissez une option:" choice_menu_group
        clear
        
        case $choice_menu_group in 

        1)add_group
        ;;

        2)remove_user_from_group
        ;;

        3)delete_empty_group
        ;;

        4)see_group
        ;;

        5)break
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
    echo "Bonjour"
    echo "1. Ajouter, modifier ou supprimer un utilisateur"
    echo "2. Gestion des groupes"
    echo "3. Attribuer des permissions"
    echo "4. Voir les utilisateur inactif"
    echo "5. Sortis"
    read -p "Choisissez une options :" user_input
    clear

    case $user_input in

        1)menu_user
        ;;

        2)menu_group
        ;;

        3)menu_permission
        ;;

        4)fonction
        ;;

        5)break
        ;;

        *)echo "Choix invalide"
        ;;

    esac
done