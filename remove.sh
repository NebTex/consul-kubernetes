#!/usr/bin/env bash

# ====================
#       Leader
# ====================
kubectl delete -f consul-leader-daemon.yml
kubectl delete -f  consul-leader-service.yml
# ====================
#       Replicas
# ====================
kubectl delete -f consul-replica-2-daemon.yml
kubectl delete -f consul-replica-2-service.yml
kubectl delete -f consul-replica-3-daemon.yml
kubectl delete -f consul-replica-3-service.yml
# ===================
#      Clients
# ===================
kubectl delete -f consul-client-daemon.yml
kubectl delete -f consul-client-service.yml