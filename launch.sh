#!/usr/bin/env bash

# download sigil
curl -fsSL https://github.com/gliderlabs/sigil/releases/download/v0.4.0/sigil_0.4.0_Linux_x86_64.tgz | tar -zxC /tmp

if kubectl get secrets --namespace kv | grep -q "consul-secrets"; then
    echo "Secrets already exists"
else
    /tmp/sigil -p -f consul-secrets.yml  acl_master_token=`uuidgen` \
acl_replication_token=`uuidgen` acl_agent_master_token=`uuidgen` \
acl_agent_token=`uuidgen` acl_token=`uuidgen` \
| kubectl  apply --validate --overwrite -f -I
fi

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
kubectl  apply -f consul-client-service.yml --validate --overwrite