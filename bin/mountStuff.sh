#!/bin/bash

zenity --info --text "Zum Mounten einiger Server wird die Smartcard benötigt.\n\nBitte jetzt Smartcard einlegen und dann OK klicken." > /dev/null 2>&1

pushd /home/mgr/ExternalMounts > /dev/null 2>&1
total=$(cat AUTOMOUNT | wc -l)
now=0
while read server
do
    #echo -ne "[    ] Mounting $server ... "
    "./mount_$server"
    now=$(($now + 1))

    content=$(ls "/home/mgr/ExternalMounts/$server")

    if [ -z "$content" ]; then
    #    echo -ne "\r[\033[0;31mfail\033[0m]"
        zenity --error "Error mounting $server\!";
    #else
    #    echo -ne "\r[ \033[0;32mok\033[0m ]"
    
    fi

    #echo

    echo $(($now * 100 / $total))
done < AUTOMOUNT | zenity --progress
popd > /dev/null 2>&1
