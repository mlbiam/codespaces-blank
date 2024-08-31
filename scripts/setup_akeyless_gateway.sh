#!/bin/bash

helm repo add akeyless https://akeylesslabs.github.io/helm-charts
helm repo update

helm show values akeyless/akeyless-api-gateway > /tmp/akeyless-gateway-values.yaml

AKEYLESS_ACCESS_ID=$(cat ~/.akeyless/profiles/default.toml  | grep access_id | awk '{print $3}' | tr -d "'")
AKEYLESS_KEY=$(cat ~/.akeyless/profiles/default.toml  | grep 'access_key =' | awk '{print $3}' | tr -d "'")

kubectl create ns akeyless
helm upgrade --install gw akeyless/akeyless-api-gateway -n akeyless --set akeylessUserAuth.adminAccessId=$AKEYLESS_ACCESS_ID --set akeylessUserAuth.adminAccessKey=$AKEYLESS_KEY --set service.type=ClusterIP


pen 10446 127.0.0.1:443

GW_HOST="$CODESPACE_NAME-10446.app.github.dev"

echo "" >> /tmp/openunison-values.yaml
echo "" >> /tmp/openunison-values.yaml

echo "akeyless_gw_host: $GW_HOST" >> /tmp/openunison-values.yaml

helm upgrade --install akeyless-lab openunison/akeyless-lab -n openunison -f /tmp/openunison-values.yaml 