#!/bin/bash

OU_HOST="$CODESPACE_NAME-443.app.github.dev"
ISSUER_URL="https://$OU_HOST/auth/idp/k8sIdp"


CLIENT_SECRET=$(kubectl get secret orchestra-secrets-source -n openunison -o json | jq -r '.data.akeyless' | base64 -d)

echo $ISSUER_URL
echo $CLIENT_SECRET

akeyless auth-method create oidc --name openunison \
--issuer "$ISSUER_URL" \
--client-id akeyless \
--client-secret $CLIENT_SECRET \
--unique-identifier sub