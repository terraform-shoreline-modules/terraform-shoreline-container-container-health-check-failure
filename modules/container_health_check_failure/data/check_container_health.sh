

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