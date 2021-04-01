#!/bin/bash

sudo apt install jq -y

ENDPOINT=https://rke.trgdev.com/v3
# Create an API Key - https://rke.trgdev.com/apikeys
ACCESS_KEY=$1
SECRET_KEY=$2

unset KUBECONFIG

CLUSTERS_ENDPOINT=$(curl -u $ACCESS_KEY:$SECRET_KEY -H "Accept: application/json" $ENDPOINT | jq -r '.links.clusters')
#echo $CLUSTERS_ENDPOINT

mkdir tmp
cd tmp

#get clusters, save config for each cluster
b=0; for i in `curl -s -u $ACCESS_KEY:$SECRET_KEY -H "Accept: application/json" $CLUSTERS_ENDPOINT | jq -r '.data[].actions.generateKubeconfig'`; do ((b=b+1)) && echo $i && curl -X POST -u $ACCESS_KEY:$SECRET_KEY -H 'Accept: application/json' "$i" | jq -r ".config" > $b.conf ; done

ls -alh

#export KUBECONFIG=~/.kube/config:~/rke_config/trg-wb
CFG=$(ls -1 | paste -sd ":" -) #concat file names
echo $CFG
export KUBECONFIG=$CFG
kubectl config view --flatten > kube_config_tmp
cat kube_config_tmp > ~/.kube/config

cd ..
rm -rf tmp
