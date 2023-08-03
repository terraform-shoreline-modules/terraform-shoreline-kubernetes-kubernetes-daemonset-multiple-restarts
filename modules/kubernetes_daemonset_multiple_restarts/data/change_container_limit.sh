bash

#!/bin/bash



# Set the namespace and deployment name

NAMESPACE=${NAMESPACE}

DAEMONSET_NAME=${DAEMONSET_NAME}



# Get the current resource limits for the containers

CURRENT_LIMITS=$(kubectl get ds $DAEMONSET_NAME -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].resources.limits}')



# Increase the CPU and memory limits by 50%

CPU_LIMIT=$(echo $CURRENT_LIMITS | sed 's/cpu=/cpu=50%/g')

MEMORY_LIMIT=$(echo $CURRENT_LIMITS | sed 's/memory=/memory=50%/g')



# Update the deployment with the new limits

kubectl patch ds $DAEMONSET_NAME -n $NAMESPACE --patch \

"{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"${CONTAINER_NAME}\",\"resources\":{\"limits\":{\"$CPU_LIMIT\",\"$MEMORY_LIMIT\"}}}]}}}}"