#!/bin/bash


Int="f"
trap 'Int="t"' INT



Admin_Mod()
{
    Int="f"
    echo "$(date) : $0 Admin Mode Start Running" >> Application.logs
    while :;do 
        select option in "System Devices Status" "Devices Control" "Network Directory Sync" "Network State" "System Power State" "Application Logs"  "Exit";do     
            case $option in 
                "System Devices Status")
                bash Devices_State.sh 
                ;;
                "Devices Control")
                bash Devices_Control.sh
                ;;      
                "Network Directory Sync")
                bash Network_sync.sh 
                ;;
                "Network State")
                bash Network_State.sh
                ;;
                "System Power State")
                bash System_Power_State.sh
                ;; 
                "Application Logs")
                    select input in "Application Logs" "Application Kernel Logs";do
                        case $input in
                        "Application Logs")
                        cat Application.logs 
                        ;;
                        "Application Kernel Logs")
                        journalctl -k -f
                        ;;
                        esac
                        break
                    done    
                ;;
                "Exit")
                echo "$(date) : $0 Admin Mode Proccess Ended" >> Application.logs
                exit 0
                ;;
            esac
            break 
        done
    done
    echo "$(date) : $0 Admin Mode Proccess Ended" >> Application.logs
}

User_Mod()
{   
    Int="f"
    echo "$(date) : $0 User Mode Start Running" >> Application.logs
     while 'true' ;do 
        select option in "System Devices Status"  "Network Directory Sync" "Network State" "Application Logs"  "Exit" ;do     
            case $option in 
                "System Devices Status")
                bash Devices_State.sh 
                ;;
                "Network State")
                bash Network_State.sh 
                ;;
                "Network Directory Sync")
                bash Network_sync.sh 
                ;;
                "Application Logs")
                    select input in "Application Logs" "System Kernel Logs";do
                        case $input in
                        "Application Logs")
                        echo "$(date) : $0 System Application logs Started" >> Application.logs
                        cat Application.logs 
                        echo "$(date) : $0 System Application logs Ended" >> Application.logs
                        ;;
                        "System Kernel Logs")
                        echo "$(date) : $0 System Kernel Logs Started" >> Application.logs
                        echo "*************Use Ctrl+c To go Back*************"
                        journalctl -k -f
                        if [ "$Int" == "t" ];then
                            echo "$(date) : $0 System Kernel Logs Ended" >> Application.logs
                            User_Mod
                        fi
                        ;;
                        esac
                        break
                    done    
                ;;
                "Exit")
                echo "$(date) : $0 User Mode Proccess Ended" >> Application.logs
                exit 0
                ;;                   
            esac
            break 
        done
    done 
}

#Check if bash is lunched with sudo
if [ ${EUID} -eq 0 ];
then 
    echo "Wellcome to Admin Mode You Can do the Following:"
    Admin_Mod
else
    echo "Wellcome to User Mode You Can do the Following:"
    User_Mod 
 fi
