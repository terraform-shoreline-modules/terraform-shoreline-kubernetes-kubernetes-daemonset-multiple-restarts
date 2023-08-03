

#!/bin/bash



# Get the resource usage metrics for the Kubernetes cluster

kubectl top nodes



# Get the resource requests and limits set for the containers running on the Daemonset

kubectl describe daemonset ${DAEMONSET_NAME} | grep -A 5 Resources



# Check if any of the resources are being over utilized by the containers

kubectl describe daemonset ${DAEMONSET_NAME} | grep -A 10 Resources | grep -i -e 'cpu' -e 'memory'



# Check if there are any resource quotas set for the Kubernetes cluster

kubectl describe quota



# Check if any nodes are underutilized or overutilized

kubectl describe nodes



# Check if there are any pod eviction events triggered by resource constraints

kubectl get events --sort-by=.metadata.creationTimestamp | grep -i 'outofmemory' | tail -n 5