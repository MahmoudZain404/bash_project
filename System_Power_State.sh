#!/bin/bash

Power_State()
{
    echo "$(date) : $0 Power State Service Start Working" >> Application.logs
    while :; do
        select option in  "Shutdown" "Reboot" "Back"; do
                case $option in 
                "Shutdown")
                echo "$(date) : $0 Admin preform a System Shutdown" >> Application.logs.txt
                shutdown now 
                ;;
                "Reboot")
                echo "$(date) : $0 Admin preform a System Reboot" >> Application.logs.txt
                reboot
                ;;
                "Back")
                echo "$(date) : $0 Power State Service Ended" >> Application.logs
                return 0 
                ;;
                esac 
                break 
            done
    done
}


Power_State
