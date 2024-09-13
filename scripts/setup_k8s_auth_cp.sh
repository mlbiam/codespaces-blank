#!/bin/bash

K8S_CP_AUTH=$(akeyless auth-method create k8s -n k8s-cp --json)

ACCESS_ID=$(echo $K8S_CP_AUTH | jq -r '.access_id')
PRIV_KEY=$(echo $K8S_CP_AUTH | jq -r '.prv_key')

GW_HOST="$CODESPACE_NAME-10446.app.github.dev"



akeyless gateway-create-k8s-auth-config  --name k8s-cp-conf \
--gateway-url https://$GW_HOST/gw \
--access-id $ACCESS_ID \
--signing-key $PRIV_KEY \
--use-gw-service-account

echo "" >> ~/conf/openunison-values.yaml
echo "" >> ~/conf/openunison-values.yaml

echo "akeyless_k8s_auth_id: $ACCESS_ID" >> ~/conf/openunison-values.yaml

helm upgrade --install akeyless-lab openunison/akeyless-lab -n openunison -f ~/conf/openunison-values.yaml 


akeyless assoc-role-am -r admin -a /k8s-cp -s namespace=openunison -s service_account_name=openunison-orchestra -s config_name=k8s-cp-conf

echo "" >> ~/conf/akeyless-gw.yaml

cat akeyless/akeyless-gw-2.yaml | sed "s,AUTH_K8S_ID,$ACCESS_ID,g" >> ~/conf/akeyless-gw.yaml

helm upgrade --install gw akeyless/akeyless-api-gateway -n akeyless -f ~/conf/akeyless-gw.yaml

kubectl delete pods --all -n akeyless