#!/bin/bash

arxiu="incidencies.txt"

menu_principal()
{
    principal_bucle=1

    while [ $principal_bucle -eq 1 ]
    do
        clear
        echo
        echo -e "\tCreador d'incidències"
        echo
        echo "1. Donar d'alta una incidència"
        echo "0. Sortir"
        echo
        
        valida=0
        while [ $valida -eq 0 ]
        do
            echo -n "Introdueix una opcio: "
            read opcio

            case $opcio in
            1) valida=1
                crear_incidencia;;
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

crear_incidencia()
{
    clear
    echo -n "Introdueix el teu email: "
    read email

    echo
    
    echo -n "Introdueix el tipus d'incidencia: "
    read tipus

    echo

    echo -n "Introdueix una descripció de l'incidencia: "
    read descripcio

    num=$(($(wc -l < $arxiu)+1))

    data=$(date +"%Y-%m-%d %H:%M")

    echo "$num;$email;$tipus;$descripcio;$data;$data;oberta;;" >> $arxiu

    clear
    echo "Incidencia creada correctament."
    echo 
    echo "Número d'incidencia: $num"
    read
}

menu_principal