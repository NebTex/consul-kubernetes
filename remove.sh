#!/usr/bin/env bash

# ====================
#       Leader
# ====================
kubectl delete -f consul-leader-daemon.yml 
kubectl delete -f consul-leader-service.yml 

# ====================
#       Replicas
# ====================
kubectl delete -f consul-statefulsets.yml 
kubectl delete -f consul-service.yml

