#!/bin/bash

OU_HOST="$CODESPACE_NAME-443.app.github.dev"
ISSUER_URL="https://$OU_HOST/auth/idp/akeyless"


CLIENT_SECRET=$(kubectl get secret orchestra-secrets-source -n openunison -o json | jq -r '.data.akeyless' | base64 -d)

echo $ISSUER_URL
echo $CLIENT_SECRET

AKEYLESS_ACCESS_ID=$(akeyless auth-method create oidc --name openunison --issuer "$ISSUER_URL" --client-id akeyless --client-secret $CLIENT_SECRET --unique-identifier sub | grep 'Access' | awk '{print $4}')

echo "AKEYLESS Access ID $AKEYLESS_ACCESS_ID"
echo "" >> /tmp/openunison-values.yaml
echo "" >> /tmp/openunison-values.yaml

echo "akeyless_access_id: $AKEYLESS_ACCESS_ID" >> /tmp/openunison-values.yaml

helm upgrade --install akeyless-lab openunison/akeyless-lab -n openunison -f /tmp/openunison-values.yaml 

akeyless assoc-role-am -r admin -a /openunison -s Groups=administrators-external