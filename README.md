
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Container Health Check Failure.
---

This incident type refers to a failure in the health check process of a container, which is a lightweight, standalone executable package that contains everything needed to run an application, including the code, libraries, and dependencies. The health check process is a mechanism that allows a container to self-assess its own state and inform the container orchestration platform whether it is ready to receive traffic or not. A failure in this process can cause the container to be marked as unhealthy and potentially disrupt the overall application performance.

### Parameters
```shell
export CONTAINER_ID="PLACEHOLDER"

export CONTAINER_NAME="PLACEHOLDER"

export EXPECTED_STATUS_CODE="PLACEHOLDER"

export HEALTH_CHECK_ENDPOINT="PLACEHOLDER"

export IO_THRESHOLD="PLACEHOLDER"

export CPU_THRESHOLD="PLACEHOLDER"

export MEM_THRESHOLD="PLACEHOLDER"
```

## Debug

### Step 1: Check the status of the container
```shell
docker ps -a
```

### Step 2: Check the logs of the container
```shell
docker logs ${CONTAINER_ID}
```

### Step 3: Check the health status of the container
```shell
docker inspect --format='{{json .State.Health}}' ${CONTAINER_ID}
```

### Step 4: Check the health check configuration of the container
```shell
docker inspect --format='{{json .Config.Healthcheck}}' ${CONTAINER_ID}
```

### Step 5: Check the network connections of the container
```shell
docker exec -it ${CONTAINER_ID} netstat -an
```

### Step 6: Check the resource usage of the container
```shell
docker stats ${CONTAINER_ID}
```

## Repair

### Check if the container is running and the health check is enabled.
```shell


#!/bin/bash



# Check if the container is running

if docker container inspect ${CONTAINER_NAME} >/dev/null 2>&1; then

    echo "Container is running."

else

    echo "Error: Container is not running."

    exit 1

fi



# Check if the container has health check enabled

if ! docker container inspect ${CONTAINER_NAME} | jq -e '.[0].State.Health.Status' >/dev/null 2>&1; then

    echo "Error: Health check is not enabled for the container."

    exit 1

fi



echo "Health check is enabled for the container."

exit 0


```

### Check if the health check endpoint is returning the expected response status code.
```shell
bash

#!/bin/bash



# Define variables

HEALTH_CHECK_ENDPOINT=${HEALTH_CHECK_ENDPOINT}

EXPECTED_STATUS_CODE=${EXPECTED_STATUS_CODE}



# Send a test request to the health check endpoint and capture the response status code

ACTUAL_STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_CHECK_ENDPOINT)



# Compare the actual status code with the expected status code

if [[ $ACTUAL_STATUS_CODE -eq $EXPECTED_STATUS_CODE ]]; then

  # The health check endpoint is returning the expected status code, no action needed

  echo "The health check endpoint is returning the expected status code"

else

  # The health check endpoint is not returning the expected status code, try restarting the container

  echo "The health check endpoint is not returning the expected status code, attempting to restart the container..."

  

  # Define variables

  CONTAINER_NAME=${CONTAINER_NAME}

  

  # Restart the container

  docker restart $CONTAINER_NAME

  

  # Wait for the container to restart and check the health check endpoint again

  sleep 10

  ACTUAL_STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_CHECK_ENDPOINT)

  

  # Compare the actual status code with the expected status code again

  if [[ $ACTUAL_STATUS_CODE -eq $EXPECTED_STATUS_CODE ]]; then

    echo "The container has been restarted and the health check endpoint is now returning the expected status code"

  else

    # The health check endpoint is still not returning the expected status code, escalate to higher-level support

    echo "The container has been restarted but the health check endpoint is still not returning the expected status code, please escalate to higher-level support"

  fi

fi


```

### Check if the container is running out of resources like CPU, memory, or I/O, causing the health check to fail.
```shell


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


```