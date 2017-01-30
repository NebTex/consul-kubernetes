#!/usr/bin/env bash
set -e

AWS_BUCKET=`cat ${VAULT_BACKUP} | jq .AWS_BUCKET -r | tr -d '\n' | base64 -w 0`
AWS_REGION=`cat ${VAULT_BACKUP} | jq .AWS_REGION -r | tr -d '\n' | base64 -w 0`
AWS_ACCESS_KEY_ID=`cat ${VAULT_BACKUP} | jq .AWS_ACCESS_KEY_ID -r -c| tr -d '\n' | base64 -w 0`
AWS_SECRET_ACCESS_KEY=`cat ${VAULT_BACKUP} | jq .AWS_SECRET_ACCESS_KEY -r | tr -d '\n' | base64 -w 0`
BORG_PASSPHRASE=`cat ${VAULT_BACKUP}| jq .BORG_PASSPHRASE -r | tr -d '\n' | base64 -w 0`

if kubectl get secrets --namespace kv | grep -q "consul-secrets"; then
    echo "Secrets already exists"
else
    sigil -p -f consul-secrets.yml secret="$(sigil -p -f consul.json  acl_master_token=`uuidgen` \
acl_replication_token=`uuidgen` acl_agent_master_token=`uuidgen` \
acl_agent_token=`uuidgen` acl_token=`uuidgen` \
| base64 -w 0)" | kubectl  apply --validate --overwrite -f -
fi


sigil -p -f consul-backup-credentials.yml AWS_BUCKET=$AWS_BUCKET AWS_REGION=$AWS_REGION \
    AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    BORG_PASSPHRASE=$BORG_PASSPHRASE  | kubectl  apply --validate --overwrite -f -
 
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
