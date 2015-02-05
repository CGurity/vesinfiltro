#!/bin/bash
id_update_server=$(curl -L -s http://creceiver.guerracarlos.com/updates/id_update.txt)
echo "Id en server: " $id_update_server
id_update_aguila=$(cat ~/archivos_locales/id_update)
echo "Id en aguila: " $id_update_aguila
lockfile=~/vesinfiltro.lock
if [ "$id_update_server" == "$id_update_aguila" ]
then
    echo "No hay updates pendientes"
else
    #lockfile
    trap "rm -f $lockfile; exit" INT TERM EXIT
    lockfile $lockfile
    echo "Actualizaciones pendientes"
    for (( c=$(( $id_update_aguila + 1)); c<=$id_update_server; c++ ))
    do
        script_pendiente=http://creceiver.guerracarlos.com/updates/"$c".sh
        echo "$script_pendiente"
        #armar el archivo de scripts correspondiente
        wget "$script_pendiente" -P ~/archivos_locales/updates/
        sh ~/archivos_locales/updates/"$c".sh
        echo "$c" > ~/archivos_locales/id_update
    done
    #lockfile
    rm -f ~/vesinfiltro.lock
    trap - INT TERM EXIT
    #cambiar id en aguila
    #~/archivos_locales/id_update << $id_update_server
    echo "actualizado"
    cat ~/archivos_locales/id_update
fi
