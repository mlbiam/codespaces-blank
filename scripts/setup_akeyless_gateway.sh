#!/bin/bash

helm repo add akeyless https://akeylesslabs.github.io/helm-charts
helm repo update

helm show values akeyless/akeyless-api-gateway > ~/conf/akeyless-gateway-values.yaml

AKEYLESS_ACCESS_ID=$(cat ~/.akeyless/profiles/default.toml  | grep access_id | awk '{print $3}' | tr -d "'")
AKEYLESS_KEY=$(cat ~/.akeyless/profiles/default.toml  | grep 'access_key =' | awk '{print $3}' | tr -d "'")
AUTH_ID=$(grep akeyless_access_id ~/conf/openunison-values.yaml | awk '{print $2}')
GW_HOST="$CODESPACE_NAME-10446.app.github.dev"

sed "s/AKEYLESS_ACCESS_ID/$AKEYLESS_ACCESS_ID/g" < akeyless/akeyless-gw.yaml | sed "s,AKEYLESS_KEY,$AKEYLESS_KEY,g" | sed "s/AUTH_ID/$AUTH_ID/g" | sed "s,GW_HOST,$GW_HOST,g"> ~/conf/akeyless-gw.yaml

kubectl create ns akeyless
helm upgrade --install gw akeyless/akeyless-api-gateway -n akeyless -f ~/conf/akeyless-gw.yaml


pen 10446 127.0.0.1:443



echo "" >> ~/conf/openunison-values.yaml
echo "" >> ~/conf/openunison-values.yaml

echo "akeyless_gw_host: $GW_HOST" >> ~/conf/openunison-values.yaml

helm upgrade --install akeyless-lab openunison/akeyless-lab -n openunison -f ~/conf/openunison-values.yaml 