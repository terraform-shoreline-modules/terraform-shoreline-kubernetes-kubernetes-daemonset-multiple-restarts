
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes Daemonset Multiple Restarts
---

This incident type refers to an alert triggered by a Kubernetes Daemonset restarting multiple times within a short period of time. This can be an indication of a problem with the application or infrastructure and needs to be investigated and resolved promptly. The incident may require collaboration between the development and operations teams to identify the root cause and implement a fix to prevent further occurrences.

### Parameters
```shell
# Environment Variables

export DAEMONSET_NAME="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export NODE_NAME="PLACEHOLDER"

export CONTAINER_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"
```

## Debug

### List all daemonsets in the default namespace
```shell
kubectl get daemonsets
```

### Describe a specific daemonset
```shell
kubectl describe daemonset ${DAEMONSET_NAME}
```

### Check the status of all daemonset pods
```shell
kubectl get pods -l 'app=${DAEMONSET_NAME}' -w
```

### Get logs for a specific pod
```shell
kubectl logs ${POD_NAME}
```

### Check the restart count for a specific pod
```shell
kubectl get pod ${POD_NAME} -o jsonpath='{.status.containerStatuses[0].restartCount}'
```

### Check the status of all nodes in the cluster
```shell
kubectl get nodes
```

### Check the status of all pods running on a specific node
```shell
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=${NODE_NAME}
```

### The Kubernetes cluster may not have enough resources to support the containers running on the Daemonset, causing them to restart frequently.
```shell


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


```

## Repair

### Increase the resources allocated to the containers to prevent them from running out of memory or CPU and causing a restart.
```shell
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


```