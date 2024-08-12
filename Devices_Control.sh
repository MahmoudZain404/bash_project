#!/bin/bash

function Device_control()
{
    echo "$(date) : $0 Device Control Service Start Running" >> Application.logs
	while :; do
		select action in "Change CPU Policy" "change Battery Trashold" "Control PC CapsLock LED" "Back";do
			case $action in
			"Change CPU Policy")
				select input in "conservative" "ondemand" "userspace" "powersave" "performance" "schedutil";do
					case $input in 
					"conservative")
						echo "conservative" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
					;; 
					"ondemand")
						echo "ondemand" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor						
					;;
					"userspace")
						echo "userspace" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
					;;
					"powersave")
						echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
					;;
				       	"performance")
						echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
					;;
					"schedutil")
						echo "schedutil" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
					;;
					esac
					break
				done
			;;
			"change Battery Trashold")
			if [ -e /sys/class/power_supply/BAT*/charge_control_start_threshold ]; then
		    read -p "Please Enter The Start Charging Treshold: " Start_cha
		    read -p "Please Enter The end Charging Treshold: " end_cha
			echo $Start_cha > /sys/class/power_supply/BAT*/charge_control_start_threshold
			echo $end_cha > /sys/class/power_supply/BAT*/charge_control_end_threshold
			else
    		echo "File does not exist. Your Application Does not Support this Feature!"
			fi
            ;;
			"Control PC CapsLock LED")
			select input_led in "LED_ON" "LED_OFF";do
			case $input_led in
			"LED_ON")
			sudo echo 1 > /sys/class/leds/input3::capslock/brightness
			;;
			"LED_OFF")
			sudo echo 0 > /sys/class/leds/input3::capslock/brightness
			;;
			esac
			break
			done
            ;;
			"Back")
            echo "$(date) : $0 Device Control Service Ended" >> Application.logs
			return 0;
            ;;
			esac
			break
		done
	done
    echo "$(date) : $0 Device Control Service Ended" >> Application.logs
}

Device_control
