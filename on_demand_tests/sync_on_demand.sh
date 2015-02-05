#!/bin/bash
id_test_server=$(curl -L -s http://creceiver.guerracarlos.com/on_demand/on_demand_id.txt)
echo "Id en server: " $id_test_server
id_test_aguila=$(cat ~/archivos_locales/id_test)
echo "Id en aguila: " $id_test_aguila
lockfile=~/vesinfiltro.lock
if [ "$id_test_server" == "$id_test_aguila" ]
then
    echo "Test de emergencia al dia"
else
    #lockfile
    trap "rm -f $lockfile; exit" INT TERM EXIT
    lockfile $lockfile
    echo "Test de emergencia pendiente"
    #mover datos habituales de ubicacion
    #   mover data/*.txt a ubicación temporal
    rm -f ~/archivos_locales/data_temporal/*
    rm -f ~/archivos_locales/experiments_temporal/*
    mv ~/.centinel/data/* ~/archivos_locales/data_temporal/
    cp ~/archivos_locales/data_temporal/device_data.txt ~/.centinel/data/
    cp ~/.centinel/experiments/* ~/archivos_locales/experiments_temporal/
    #   restituir los últimos experimentos on_demand
    cp ~/archivos_locales/experiments_od/* ~/.centinel/experiments/
    #descargar -datos-y experimentos que hagan falta
    #   descargar ciegamente data on demand del server
    #   comparar experimentos y descargar lo que toque
    ########
    shopt -s nullglob
    experimentsdelete=(~/.centinel/experiments/*.py)
    totalexperimentsdelete=${#experimentsdelete[*]}
    initfile=(~/.centinel/experiments/__init__.py)
    data_exp=(~/.centinel/experiments/device_data.py)
    for (( i=0; i<=$(( $totalexperimentsdelete -1 )); i++ ))
    do
        if [ "${experimentsdelete[$i]}" == "$initfile" ]
        then
            experimentsdelete[$i]=""
        fi
        if [ "${experimentsdelete[$i]}" == "$data_exp" ]
        then
            experimentsdelete[$i]=""
        fi
    done

    cambios=0
    for i in $(wget -O- -q http://creceiver.guerracarlos.com/on_demand/control.txt)
    do
        IFS=','
        read -a array <<< "${i}"
        experiment="${array[0]}"
        md5experimentcontrol="${array[1]}"
        experimentfile=(~/.centinel/experiments/$experiment.py)
        datafile=(~/.centinel/data/$experiment.txt)
        dataserver="http://creceiver.guerracarlos.com/on_demand/data/$experiment.txt"
        wget "$dataserver" -P ~/.centinel/data/
        #Perdonar los experimentos que ya existan
        for (( i=0; i<=$(( $totalexperimentsdelete -1 )); i++ ))
        do
            if [ "${experimentsdelete[$i]}" == "$experimentfile" ]
            then
                experimentsdelete[$i]=""
            fi
        done
        
        if [ -f $experimentfile ]
        then
            md5experimentaguila=$(md5sum ${experimentfile} | awk '{ print $1 }')
            if [ "$md5experimentcontrol" != "$md5experimentaguila" ]
            then
                echo "son diferentes los hashes del experimento para $experiment"
                rm $experimentfile
                experimentserver="http://creceiver.guerracarlos.com/on_demand/experiments/$experiment.py"
                wget $experimentserver -P ~/.centinel/experiments/
            fi
        else
            #else si el archivo correspondiente no esta en el aguila     
            experimentserver="http://creceiver.guerracarlos.com/on_demand/experiments/$experiment.py"
            wget $experimentserver -P ~/.centinel/experiments/
        fi
    done
    #########
    
    #centinel-dev
    centinel-dev
    #enviar.py
    python ~/vesinfiltro/send_results.py
    #reestablecer archivos habituales
    rm -f ~/.centinel/data/*
    mv ~/.centinel/experiments/* ~/archivos_locales/experiments_od/
    mv ~/archivos_locales/data_temporal/* ~/.centinel/data/
    mv~/experiments_locales/experiments_temporal/* ~/.centinel/experiments/
    #lockfile
    rm -f ~/vesinfiltro.lock
    trap - INT TERM EXIT
    #cambiar id en aguila
    ~/archivos_locales/id_test << $id_test_server
fi
