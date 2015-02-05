#!/bin/bash
id_update_server=$(curl -L -s http://creceiver.guerracarlos.com/updates/id_update.txt)
echo "Id en server: " $id_update_server
id_update_aguila=$(cat /home/pi/archivos_locales/id_update)
echo "Id en aguila: " $id_update_aguila
lockfile=/home/pi/vesinfiltro.lock
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
        wget "$script_pendiente" -P /home/pi/archivos_locales/updates/
        sh /home/pi/archivos_locales/updates/"$c".sh
        echo "$c" > /home/pi/archivos_locales/id_update
    done
    #lockfile
    rm -f /home/pi/vesinfiltro.lock
    trap - INT TERM EXIT
    #cambiar id en aguila
    #/home/pi/archivos_locales/id_update << $id_update_server
    echo "actualizado"
    cat /home/pi/archivos_locales/id_update
fi
