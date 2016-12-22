#!/usr/bin/env bash

# ====================
#       Leader
# ====================
kubectl apply -f consul-leader-daemon.yml --validate --overwrite
kubectl apply -f consul-leader-service.yml --validate --overwrite
# ====================
#       Replicas
# ====================
kubectl apply -f consul-replica-2-daemon.yml --validate --overwrite
kubectl apply -f consul-replica-2-service.yml --validate --overwrite
kubectl apply -f consul-replica-3-daemon.yml --validate --overwrite
kubectl apply -f consul-replica-3-service.yml --validate --overwrite
# ===================
#      Clients
# ===================
kubectl  apply -f consul-client-daemon.yml --validate --overwrite
kubectl apply -f consul-client-service.yml --validate --overwrite