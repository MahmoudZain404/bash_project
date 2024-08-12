#!/usr/bin/


Back="n"
quit="y"
trap 'Back="y"' INT


function CPU_Usage()
{       
	echo "$(date) : $0 CPU Usage service Start Running" >> Application.logs
	Back="n"
	printf "\n** CPU Usage Service Update Every 1 Sec. to Go Back Press Ctrl+c **\n"
	while :; do
        # Get the first line of all CPUs 
        cpu_now=($(head -n1 /proc/stat))
        # Get all columns but skip the first (which is the "cpu" string) 
        cpu_sum="${cpu_now[@]:1}"
        # Replace the column seperator (space) with + 
        cpu_sum=$((${cpu_sum// /+}))
        # Get the difference between two reads 
        cpu_delta=$((cpu_sum - cpu_last_sum))
        # Get the idle time Delta 
        cpu_idle=$((cpu_now[4]- cpu_last[4]))
        # Calc time spent working 
        # Calc percentage 
        cpu_usage=$((100 * cpu_used / cpu_delta))

        # Keep this as last for our next read 
         cpu_last=("${cpu_now[@]}")
         cpu_last_sum=$cpu_sum
	 	 temp=`cat /sys/devices/platform/coretemp.0/hwmon/hwmon?/temp1_input`
	 	 temp=$(($temp/1000))
         printf "\nCPU usage at %s    temp: %s     %s \n" "$cpu_usage%" "$temp°C" "$(sed -n '8p' < /proc/cpuinfo)MHz"
         if [[ "$Back" == "$quit" ]];then
            break
         fi	
		# Wait a second before the next read 
         sleep 1
	done
	echo "$(date) : $0 CPU Usage service Ended" >> Application.logs
	return 0
}



function Mem_Usage()
{
	echo "$(date) : $0 Memory Usage service Start Running" >> Application.logs
	Back="n"
	printf "\n** RAM Usage Service Update Every 1 Sec. to Go Back Press Ctrl+c **\n"
	while :; do
	
		# Define RAM threshold
		ramthreshold=90.0

		# Fetch memory data from /proc/meminfo
		MemFree=$(grep MemFree /proc/meminfo | awk '{print $2}')

		Buffers=$(grep Buffers /proc/meminfo | awk '{print $2}')

		Cached=$(grep -i Cached /proc/meminfo | grep -v SwapCached | awk '{print $2}')

		MemTotal=$(grep MemTotal /proc/meminfo | awk '{print $2}')
		
		SReclaimable=$(grep SReclaimable /proc/meminfo | awk '{print $2}')

		SUnreclaim=$(grep SUnreclaim /proc/meminfo | awk '{print $2}')

		# Calculate RAM utilization
		total=$(echo "scale=2; $MemTotal / 1000000" | bc -l)
		
		used_memory=$(echo "scale=0; ($MemTotal - $MemFree - $Buffers - $Cached - $SReclaimable) / 1024 " | bc -l)

		used_memory_percentage=$(echo "scale=2; ($MemTotal - $MemFree - $Buffers - $Cached - $SReclaimable) / $MemTotal * 100" | bc -l)


		if (( $(echo "$used_memory_percentage >= $ramthreshold" | bc -l) )); then

		# Print the table header in a box

		#echo "Memory Utilized = ( ( Total - Free ) / Total * 100 ) =" $used_memory_percentage "%"

		printf "+------------------+-------------------+------------------+--------\n"

		printf "|%-15s | %-17s | %-16s | %-06s |\n" "Total Memory (GB)" "Used Memory (MB)" "Used Memory (%)" "Status"

		printf "+------------------+-------------------+------------------+--------\n"


		# Print the table rows

		printf "|      %-17s |      %-16s |      %-15s | %-06s${NC} |\n" "$total" "$used_memory" "$used_memory_percentage %" "High"


		# Print the bottom border of the table box

		printf "+------------------+-------------------+------------------+--------\n"

		if [[ "$Back" == "$quit" ]];then
            break
        fi	

		else

		# Print the table header in a box

		#echo "Memory Utilized = ( ( Total - Free ) / Total * 100 ) =" $used_memory_percentage "%"

		printf "+------------------+-------------------+------------------+--------\n"

		printf "|%-15s | %-17s | %-16s | %-06s |\n" "Total Memory (GB)" "Used Memory (MB)" "Used Memory (%)" "Status"

		printf "+------------------+-------------------+------------------+--------\n"


		# Print the table rows

		printf "|      %-11s |      %-12s |      %-11s | %-04s${NC} |\n" "$total" "$used_memory" "$used_memory_percentage %" "Normal"


		# Print the bottom border of the table box

		printf "+------------------+-------------------+------------------+--------\n"

		fi

		if [[ "$Back" == "$quit" ]];then
            break
        fi	

		sleep 1
	done
	echo "$(date) : $0 Memory Usage service Ended" >> Application.logs
	return 0
}

function Disk_Usage()
{
	echo "$(date) : $0 Disk Usage service Start Running" >> Application.logs

	Total_Disk_Space=($(df | awk '{print $2}' | awk "NR!=1"))

	Total_Used_Space=($(df | awk '{print $3}' | awk "NR!=1"))

	Total_Avail_Space=($(df | awk '{print $4}' | awk "NR!=1"))

	for i in ${Total_Disk_Space[@]}; do ((Disk_sum+= $i)); done

	for i in ${Total_Used_Space[@]}; do ((Used_sum+= $i)); done

	for i in ${Total_Avail_Space[@]}; do ((Avail_sum+= $i)); done 

	Disk_Usage=$(echo "scale=2; $Used_sum*100/$Disk_sum" | bc -l)

	Avail_Space_GB=$(echo "scale=2; ($Avail_sum / 1024) / 1024" | bc -l)

	printf "\nUsed Disk Space in Percent: %s Total Free Space: %s \n" "$Disk_Usage%" "$Avail_Space_GB GB"
	
	echo "$(date) : $0 Disk Usage service Ended" >> Application.logs
}


function Device_Status()
{
	echo "$(date) : $0 Device Status Start Running" >> Application.logs
	while :;do
		Back="n"
		select option in "CPU info" "RAM Usage" "Disk Usage" "Back";do
			case $option in
				"CPU info")
				CPU_Usage
				;;
				"RAM Usage")
				Mem_Usage
				;;
				"Disk Usage")
				Disk_Usage
				;;
				"Back")
				echo "$(date) : $0 Device Status service Ended" >> Application.logs
				return 0
				;;
			esac
			break
		done
	done
	
}


Device_Status










