#!/bin/bash

Back="n"
quit="y"
trap 'Back="y"' INT

function Network_State()
{
    echo "$(date) : $0 Network_State Service Start Running" >> Application.logs
    printf "\n**If You Want to Back to previous Menu Please Press Ctrl+c**\n"
    # Log file location
    LOGFILE="./Application.logs"

    # Get the current date and time
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Get the IP address
    ip_address=$(hostname -I | awk '{print $1}')

    # Get DNS servers
    dns_servers=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}')

    # Calculate download and upload rate (assuming eth0 interface)
    Net_Devices=$(ls /sys/class/net) 
    printf "Your Netwok Devices: \n%s\n" "$Net_Devices"
    read -p "Please type in the device you are using to connect to internet: " interface

    while :; do
        rx_before=$(cat /sys/class/net/$interface/statistics/rx_bytes)
        tx_before=$(cat /sys/class/net/$interface/statistics/tx_bytes)
        sleep 1
        rx_after=$(cat /sys/class/net/$interface/statistics/rx_bytes)
        tx_after=$(cat /sys/class/net/$interface/statistics/tx_bytes)
        download_rate=$(( (rx_after - rx_before) / 1024 ))
        upload_rate=$(( (tx_after - tx_before) / 1024 ))
        # Log the information
        echo "[$timestamp] IP: $ip_address, DNS: $dns_servers, Download: ${download_rate}KB/s, Upload: ${upload_rate}KB/s" #>> $LOGFILE

        if [[ "$Back" == "$quit" ]];then
            break
        fi
    done
    echo "$(date) : $0 Network_State Service Start Running" >> Application.logs
    return 0
}

Network_State