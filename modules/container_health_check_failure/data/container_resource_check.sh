

#!/bin/bash



# Define variables

CONTAINER_NAME="${CONTAINER_NAME}"



# Check container resource usage

CPU_USAGE=$(docker stats --no-stream --format "{{.CPUPerc}}" $CONTAINER_NAME | awk -F'%' '{print $1}')

MEM_USAGE=$(docker stats --no-stream --format "{{.MemUsage}}" $CONTAINER_NAME | awk -F'/' '{print $1}')

DISK_IO=$(docker stats --no-stream --format "{{.BlockIO}}" $CONTAINER_NAME | awk -F'/' '{print $1}')



# Define resource thresholds

CPU_THRESHOLD=${CPU_THRESHOLD}

MEM_THRESHOLD=${MEM_THRESHOLD}

IO_THRESHOLD=${IO_THRESHOLD}



# Check if resource usage exceeds thresholds

if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then

    echo "CPU usage is above the threshold of $CPU_THRESHOLD"

fi



if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then

    echo "Memory usage is above the threshold of $MEM_THRESHOLD"

fi



if (( $(echo "$DISK_IO > $IO_THRESHOLD" | bc -l) )); then

    echo "Disk I/O is above the threshold of $IO_THRESHOLD"

fi