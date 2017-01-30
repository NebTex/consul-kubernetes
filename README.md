# Consul DaemonSet for Kubernetes (only for private networks under you control)

this will setup `consul`  in all the nodes of the k cluster. 

### Before install

1. this only works with weave network
2. all the cluster run over a vpn  (https://github.com/NebTex/tzk)

### Minimal requirements (3 nodes)

1. create the namespace `kv`
2. label a node as `kv-store-leader=yes`
3. label other 2 nodes as `kv-store-replica-2=yes`, `kv-store-replica-3=yes`
4. make writable your /data directory in the 3 kv nodes for other users different of root

### Specs

1. it will initially launch the consul-leader and create a service called `consul-leader` on the `kv` namespace
2. consul leader instance only will run on the node labeled as `kv-store-leader=yes`
3. next it will launch two other consul services with the name of `consul-replica-2, consul-replica-3` in the nodes labeled as `kv-store-replica-2=yes`, `kv-store-replica-3=yes`
4. after this an instance of consul in client mode will be present in each node of the k cluster even the master ones
5. the consul client cluster connect to the master using the `consul-leader` dns entry
6. then create another service for the consul client with the dns entry `consul`
7. it will generate all the acl tokens and store them in consul-secrets, they need to be removed manually in case in which you want to delete or change them

### Usage

run the `launch.sh` on the kube master, this will create or update the installation 

### Remove

just run `remove.sh` on master

## Licence

Copyright (c) 2016 NebTex

MIT
