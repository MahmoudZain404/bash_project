#!/bin/bash

Int="f"
trap 'Int="t"' INT


function Network_Sync()
{   
    Int="f"
    echo "$(date) : $0 Network_Sync Service Start Running" >> Application.logs
    read -p "Please Enter Source_dir Path: " source_dir
    read -p "Please Enter target_dir Path: " target_dir
    read -p "Please Enter target_ip: " target_ip
    read -p "Please Enter username: " username
    read -p "Please Enter port: " port

    # Validate inputs
    if [ -z "${source_dir}" ] || [ -z "${target_dir}" ] || [ -z "${target_ip}" ]; then
        echo "Error Empty Required Field!"
        exit 1
    fi

    # Set default username and port if not provided
    username=${username:-$USER}
    port=${port:-22}

    # Perform synchronization using rsync
    rsync -avz -e "ssh -p ${port}" "${source_dir}/" "${username}@${target_ip}:${target_dir}/"

    if [ "$Int" == "t" ];then
        echo "$(date) : $0 Network_Sync Service Ended" >> Application.logs
        echo "Synchronization failed."
        return 0
    fi

    # Check exit status
    if [ $? -eq 0 ]; then
        echo "Synchronization completed successfully."
    else
        echo "Synchronization failed."
    fi

    echo "$(date) : $0 Network_Sync Service Ended" >> Application.logs
}

Network_Sync