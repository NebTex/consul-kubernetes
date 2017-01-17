#!/usr/bin/env bash

if kubectl get secrets --namespace kv | grep -q "consul-secrets"; then
    echo "Secrets already exists"
else
    sigil -p -f consul-secrets.yml secret="$(sigil -p -f consul.json  acl_master_token=`uuidgen` \
acl_replication_token=`uuidgen` acl_agent_master_token=`uuidgen` \
acl_agent_token=`uuidgen` acl_token=`uuidgen` \
| base64 -w 0)" | kubectl  apply --validate --overwrite -f -
fi

# ====================
#       Leader
# ====================

kubectl apply -f consul-leader-daemon.yml --validate --overwrite
kubectl apply -f consul-leader-service.yml --validate --overwrite

# ====================
#       Replicas
# ====================

kubectl apply -f consul-statefulsets.yml --validate --overwrite
kubectl apply -f consul-service.yml --validate --overwrite
