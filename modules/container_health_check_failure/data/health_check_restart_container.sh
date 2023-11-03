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