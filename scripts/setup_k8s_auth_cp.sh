#!/bin/bash

K8S_CP_AUTH=$(akeyless auth-method create k8s -n k8s-cp --json)

ACCESS_ID=$(echo $K8S_CP_AUTH | jq -r '.access_id')
PRIV_KEY=$(echo $K8S_CP_AUTH | jq -r '.prv_key')

GW_HOST="$CODESPACE_NAME-10446.app.github.dev"

akeyless gateway-create-k8s-auth-config  --name k8s-cp-conf \
--gateway-url https://$GW_HOST \
--access-id $ACCESS_ID \
--signing-key $PRIV_KEY \
--use-gw-service-account