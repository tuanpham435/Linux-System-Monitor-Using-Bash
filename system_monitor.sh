#!/bin/bash

# Set threshold values
CPU_THRESHOLD=80
MEMORY_THRESHOLD=90
DISK_THRESHOLD=95

# Function to send alerts
send_alert() {
    local resource=$1
    local value=$2
    echo "ALERT: $resource usage exceeded threshold. Current usage: $value%"
    # Add your desired alert mechanism here (e.g., send email, SMS, or push notification)
}

while true; do
    # Clear the screen
    clear

    # Monitor CPU usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        send_alert "CPU" "$cpu_usage"
    fi

    # Monitor memory usage
    memory_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
    if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        send_alert "Memory" "$memory_usage"
    fi

    # Monitor disk usage
    disk_usage=$(df -h | awk '$NF=="/"{print $5}' | cut -d'%' -f1)
    if (( $(echo "$disk_usage > $DISK_THRESHOLD" | bc -l) )); then
        send_alert "Disk" "$disk_usage"
    fi

    # Display resource usage
    printf "Resource\tUsage (%%)\n"
    printf "%s\n" "-------------------------"
    printf "CPU Usage\t%.2f\n" "$cpu_usage"
    printf "Memory Usage\t%.2f\n" "$memory_usage"
    printf "Disk Usage\t%d\n" "$disk_usage"
    printf "\nPress 'q' to quit.\n"
 
    # Wait for user input
    read -t 1 -n 1 input
    if [[ $input == "q" ]]; then
        break
    fi

    # Sleep for 1 second
    sleep 1
done
