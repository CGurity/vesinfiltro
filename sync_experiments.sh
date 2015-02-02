#!/bin/bash

shopt -s nullglob
experimentsdelete=(~/.centinel/experiments/*.py)
totalexperimentsdelete=${#experimentsdelete[*]}

data_exp=(~/.centinel/experiments/device_data.py)
data_data=(~/.centinel/data/device_data.txt)
initfile=(~/.centinel/experiments/__init__.py)

datadelete=(~/.centinel/data/*.txt)
totaldatadelete=${#datadelete[*]}

#echo ${experimentsdelete[@]}

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

for (( i=0; i<=$(( $totaldatadelete -1 )); i++ ))
do
    if [ "${datadelete[$i]}" == "$data_data" ]
    then
        datadelete[$i]=""
    fi
done

cambios=0
for i in $(wget -O- -q http://creceiver.guerracarlos.com/control.txt)
do
    #arr=(${i//,/ })
    IFS=','
    read -a array <<< "${i}"
    experiment="${array[0]}"
    md5experimentcontrol="${array[1]}"
    md5datacontrol="${array[2]}"
    experimentfile=(~/.centinel/experiments/$experiment.py)
    
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

        datafile=(~/.centinel/data/$experiment.txt)
        
        for (( i=0; i<=$(( $totaldatadelete -1 )); i++ ))
        do
            if [ "${datadelete[$i]}" == "$datafile" ]
            then
                datadelete[$i]=""
            fi
        done
        
        if [ -f $datafile ]
        then
            md5dataaguila=$(md5sum ${datafile} | awk '{ print $1 }')
            #echo "md5data en cliente: $md5dataaguila"
            #echo "md5data en server: $md5datacontrol"
            if [ "$md5experimentcontrol" != "$md5experimentaguila" ]
            then
                echo "son diferentes los hashes del experimento para $experiment"
                rm $experimentfile
                experimentserver="http://creceiver.guerracarlos.com/experiments/$experiment.py"
                wget $experimentserver -P ~/.centinel/experiments/
                cambios=1
            fi
            if [ "$md5datacontrol" != "$md5dataaguila" ]
            then
                echo "son diferentes los hashes del data para $experiment"
                rm $datafile
                dataserver="http://creceiver.guerracarlos.com/data/$experiment.txt"
                wget "$dataserver" -P ~/.centinel/data/
                cambios=1
            fi
        else
            dataserver="http://creceiver.guerracarlos.com/data/$experiment.txt"
            wget "$dataserver" -P ~/.centinel/data/
        fi
    else
        #else si el archivo correspondiente no esta en el aguila     
        experimentserver="http://creceiver.guerracarlos.com/experiments/$experiment.py"
            wget $experimentserver -P ~/.centinel/experiments/
        if [ ! -f $datafile ]
        then
            dataserver="http://creceiver.guerracarlos.com/data/$experiment.txt"
            wget "$dataserver" -P ~/.centinel/data/
        else
            #pegaaqui
            datafile=(~/.centinel/data/$experiment.txt)
            md5dataaguila=$(md5sum ${datafile} | awk '{ print $1 }')
            if [ "$md5datacontrol" != "$md5dataaguila" ]
            then
                echo "son diferentes los hashes del data para $experiment"
                rm $datafile
                dataserver="http://creceiver.guerracarlos.com/data/$experiment.txt"
                wget "$dataserver" -P ~/.centinel/data/
                cambios=1
            fi
	   fi
    fi
done

for (( i=0; i<=$(( $totalexperimentsdelete -1 )); i++ ))
do
    if [ "${experimentsdelete[$i]}" != "" ]
    then
        echo "rm ${experimentsdelete[$i]}"
        rm -f ${experimentsdelete[$i]}
        rm -f ${experimentsdelete[$i]}c
    fi
done

for (( i=0; i<=$(( $totaldatadelete -1 )); i++ ))
do
    if [ "${datadelete[$i]}" != "" ]
    then
        echo "rm WW${datadelete[$i]}WW"
        rm -f ${datadelete[$i]}
    fi
done

#echo ${#experimentsdelete[@]}
#echo ""
#echo ${datadelete[@]}

#wget -c -m -np -nH --cut-dirs=1 -A.txt http://creceiver.guerracarlos.com/data/ -P /home/aguila2/.centinel/data/
