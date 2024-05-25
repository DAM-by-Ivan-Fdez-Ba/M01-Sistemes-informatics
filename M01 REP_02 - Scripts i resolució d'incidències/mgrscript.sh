#!/bin/bash

arxiu="incidencies.txt"

menu_principal()
{
    principal_bucle=1

    while [ $principal_bucle -eq 1 ]
    do
        clear
        echo
        echo -e "\tAdministració d'incidències"
        echo
        echo "1. Gestionar incidències"
        echo "2. Resoldre incidència"
        echo "0. Sortir"
        echo
        
        valida=0
        while [ $valida -eq 0 ]
        do
            echo -n "Introdueix una opcio: "
            read opcio

            case $opcio in
            1) valida=1
                gestionar_incidencies;;
            2) valida=1
                resoldre_incidencia;;
            0) valida=1
                principal_bucle=0
                clear;;
            *) echo
                echo "Opcció no vàlida"
                echo;;
            esac
        done
    done
}

gestionar_incidencies()
{
    bucle=1

    while [ $bucle -eq 1 ]
    do
        clear
        echo
        echo -e "\tGestionar incidències"
        echo
        echo "1. Mostrar totes les incidències"
        echo "2. Mostrar les incidències obertes"
        echo "3. Mostrar les incidències en procés"
        echo "4. Mostrar les incidències tancades"
        echo "5. Mostrar incidència completa"
        echo "6. Canviar d'estat una incidència"
        echo "0. Sortir"
        echo
        
        valida=0
        while [ $valida -eq 0 ]
        do
            echo -n "Introdueix una opcio: "
            read opcio

            case $opcio in
            1) valida=1
                mostrar_incidencies "totes";;
            2) valida=1
                mostrar_incidencies "oberta";;
            3) valida=1
                mostrar_incidencies "proces";;
            4) valida=1
                mostrar_incidencies "tancada";;
            5) valida=1
                mostrar_incidencia_completa;;
            6) valida=1
                canviar_estat_incidencia;;
            0) valida=1 
                bucle=0;;
            *) echo
                echo "Opcció no vàlida"
                echo;;
            esac
        done
    done
}

mostrar_incidencies()
{
    clear
    OLD_IFS=$IFS
    IFS=';'

    num_incidencies=$(wc -l < "$arxiu")

    echo
    case $1 in
        "totes") echo "Llista de totes les incidències:";;
        "oberta") echo "Llista d'incidències obertes:";;
        "proces") echo "Llista d'incidències en procés:";;
        "tancada") echo "Llista d'incidències en tancades:";;
    esac  
    echo

    for ((i=1; i<="num_incidencies"; i++))
    do
        read num email tipus descripcio data_creacio data_modificacio estat tecnic comentari <<< $(sed -n "${i}p" "$arxiu")
        
        if [ "$1" = "$estat" ] || [ "$1" = "totes" ]
        then
            echo "$num. $tipus: $estat"
        fi
    done
    echo
    echo -n "Enter per continuar"    
    read
    IFS=$OLD_IFS
}

mostrar_incidencia_completa()
{
    seleccionar_incidencia
    clear
    echo
    echo "Incidència $num"
    echo
    echo "Email de l'usuari: $email"
    echo "Tipus d'incidència: $tipus"
    echo "Descripció: $descripcio"
    echo "Data d'apertura: $data_creacio"
    echo "Data ultima modificació: $data_modificacio"
    echo "Estat: $estat"
    echo "Nom de la persona que l'ha resolt: $tecnic"
    echo "Comentari: $comentari"
    echo
    echo -n "Enter per continuar"    
    read
}

seleccionar_incidencia()
{
    num_incidencies=$(wc -l < "$arxiu")
    clear
    echo
    echo -n "Introdueix un número d'incidència:"
    read num_incidencia

    while [ -z "$num_incidencia" ] || [ $num_incidencia -gt $num_incidencies ] || [ $num_incidencia -lt 1 ]
    do
        echo
        echo "Opcció no vàlida"
        echo
        echo -n "Introdueix un número d'incidència vàlid: "
        read num_incidencia
    done

    OLD_IFS=$IFS
    IFS=';'
    read num email tipus descripcio data_creacio data_modificacio estat tecnic comentari <<< $(sed -n "${num_incidencia}p" "$arxiu")
    IFS=$OLD_IFS
}

canviar_estat_incidencia()
{
    seleccionar_incidencia
    clear
    echo
    if [ "$estat" = "tancada" ]
        then
            echo "Aquesta incidència ja està tancada."
    else 
        data=$(date +"%Y-%m-%d %H:%M")
        if [ "$estat" = "proces" ]
        then
            estat="tancada"
            echo "L'estat de la incidència ha passat d'en procés a tancada." 
        else
            estat="proces"
            echo "L'estat de la incidència ha passat d'oberta a en procés."
        fi
        tecnic=$USER
        data_modificacio=$data
        echo
        echo -n "Comentari sobre la resolució: "
        read comentari
        incidencia="$num;$email;$tipus;$descripcio;$data_creacio;$data_modificacio;$estat;$tecnic;$comentari"
        sed -i "${num_incidencia}s/.*/$incidencia/" "$arxiu"
        clear
        echo
        echo "L'estat de l'incidència s'ha canviat correctament."
    fi
    echo
    echo -n "Enter per continuar"    
    read
}

resoldre_incidencia()
{
    bucle=1

    while [ $bucle -eq 1 ]
    do
        clear
        echo
        echo -e "\tResoldre incidències"
        echo
        echo "1. Afegir o eliminar usuaris"
        echo "2. Gestionar servei FTP"
        echo "3. Resoldre problemes d'accés al lloc web"
        echo "4. Modificar pàgina web"
        echo "0. Sortir"
        echo
        
        valida=0
        while [ $valida -eq 0 ]
        do
            echo -n "Introdueix una opcio: "
            read opcio

            case $opcio in
            1) valida=1
                gestionar_usuaris;;
            2) valida=1
                gestionar_servei_web_FTP;;
            3) valida=1
                resoldre_problemes_web;;
            4) valida=1
                modificar_web;;
            0) valida=1 
                bucle=0;;
            *) echo
                echo "Opcció no vàlida"
                echo;;
            esac
        done
    done
}

gestionar_usuaris()
{
    sub_bucle=1

    while [ $sub_bucle -eq 1 ]
    do
        clear
        echo
        echo -e "\tGestionar usuaris per al servidor FTP"
        echo
        echo "1. Afegir"
        echo "2. Eliminar"
        echo "0. Sortir"
        echo
        
        valid=0
        while [ $valid -eq 0 ]
        do
            echo -n "Introdueix una opcio: "
            read opcio

            case $opcio in
            1) valid=1
            demanar_nom_usuari
            sudo adduser "$nom_usuari";;
            2) valid=1
            demanar_nom_usuari   
            sudo deluser "$nom_usuari";;                                    
            0) valid=1 
                sub_bucle=0;;
            *) echo
                echo "Opcció no vàlida"
                echo;;
            esac
        done
    done  
}

demanar_nom_usuari()
{
    clear
    echo
    echo -n "Introdueix el nom de l'usuari: "
    read nom_usuari
}

gestionar_servei_web_FTP()
{
    sub_bucle=1

    while [ $sub_bucle -eq 1 ]
    do
        clear
        echo
        echo -e "\tGestionar servei web i FTP"
        echo
        echo "1. Iniciar"
        echo "2. Aturar"
        echo "3. Reiniciar"
        echo "4. Conèixer l'estat"
        echo "0. Sortir"
        echo
        
        valid=0
        while [ $valid -eq 0 ]
        do
            echo -n "Introdueix una opcio: "
            read opcio

            case $opcio in
            1) valid=1
                gestio_ftp "iniciar";;
            2) valid=1
                gestio_ftp "aturar";;
            3) valid=1
                gestio_ftp "reiniciar";;
            4) valid=1
                gestio_ftp "estat";;                                       
            0) valid=1
                sub_bucle=0;;
            *) echo
                echo "Opcció no vàlida"
                echo;;
            esac
        done
    done
}

gestio_ftp()
{
    clear
    echo
    case $1 in
    "iniciar") sudo service vsftpd start
                echo "El servei FTP s'ha iniciat correctament.";;
    "aturar") sudo service vsftpd stop
                echo "El servei FTP s'ha aturat correctament.";;
    "reiniciar") sudo service vsftpd restart
                echo "El servei FTP s'ha reiniciat correctament.";;
    "estat") sudo service vsftpd status;;
    esac
    echo
    echo -n "Enter per continuar"    
    read
}

resoldre_problemes_web()
{
    clear
    echo
    echo -e "\tGestionar permisos del lloc web"
    echo
    echo "1. Publicar"
    echo "2. Privatitzar"
    echo "0. Sortir"
    echo

    valid=0
        while [ $valid -eq 0 ]
        do
            echo -n "Introdueix una opcio: "
            read opcio

            case $opcio in
            1) valid=1
                permisos_web "public";;
            2) valid=1
                permisos_web "privat";;                   
            0) valid=1
                sub_bucle=0;;
            *) echo
                echo "Opcció no vàlida"
                echo;;
            esac
        done

}

permisos_web()
{
    clear
    echo
    case $1 in
    "public") sudo chmod -R 755 /var/www/html
                echo "La web s'ha tornat pública";;
    "privat") sudo chmod -R 700 /var/www/html
                echo "La web s'ha tornat privada";;
    esac
    echo
    echo -n "Enter per continuar"    
    read
}

modificar_web()
{
    code /var/www/html
}

menu_principal

