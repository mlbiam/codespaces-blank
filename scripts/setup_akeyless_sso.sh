#!/bin/bash

OU_HOST="$CODESPACE_NAME-443.app.github.dev"
ISSUER_URL="https://$OU_HOST/auth/idp/akeyless"


CLIENT_SECRET=$(kubectl get secret orchestra-secrets-source -n openunison -o json | jq -r '.data.akeyless' | base64 -d)

echo $ISSUER_URL
echo $CLIENT_SECRET

GW_HOST="$CODESPACE_NAME-10446.app.github.dev"

#AKEYLESS_ACCESS_ID=$(akeyless auth-method create oidc --name openunison --issuer "$ISSUER_URL" --client-id akeyless --client-secret $CLIENT_SECRET --unique-identifier sub  --allowed-redirect-uri "https://console.akeyless.io/login-oidc,https://zerotrust.akeyless.io,http://127.0.0.1:*,http://localhost:*,https://$GW_HOST/gw/login-oidc" | grep 'Access' | awk '{print $4}')
AKEYLESS_ACCESS_ID=$(akeyless auth-method create oidc --name openunison --issuer "$ISSUER_URL" --client-id akeyless --client-secret $CLIENT_SECRET --unique-identifier sub   | grep 'Access' | awk '{print $4}')

echo "AKEYLESS Access ID $AKEYLESS_ACCESS_ID"
echo "" >> ~/conf/openunison-values.yaml
echo "" >> ~/conf/openunison-values.yaml

echo "akeyless_access_id: $AKEYLESS_ACCESS_ID" >> ~/conf/openunison-values.yaml

helm upgrade --install akeyless-lab openunison/akeyless-lab -n openunison -f ~/conf/openunison-values.yaml 

akeyless assoc-role-am -r admin -a /openunison -s Groups=administrators-external