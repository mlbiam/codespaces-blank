#!/bin/bash

helm repo add akeyless https://akeylesslabs.github.io/helm-charts
helm repo update

helm show values akeyless/akeyless-api-gateway > /tmp/akeyless-gateway-values.yaml

AKEYLESS_ACCESS_ID=$(cat ~/.akeyless/profiles/default.toml  | grep access_id | awk '{print $3}')
AKEYLESS_KEY=$(cat ~/.akeyless/profiles/default.toml  | grep 'access_key =' | awk '{print $3}')