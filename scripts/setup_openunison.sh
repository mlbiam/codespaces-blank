#!/bin/bash

# install pen to setup additional ports to forward
sudo apt-get update
sudo apt-get install pen

# setup pen for the dashboard and API server
pen 10444 127.0.0.1:443
pen 10445 127.0.0.1:443

OU_HOST="$CODESPACE_NAME-443.app.github.dev"
DB_HOST="$CODESPACE_NAME-10444.app.github.dev"
API_HOST="$CODESPACE_NAME-10445.app.github.dev"

echo $OU_HOST
echo $DB_HOST
echo $API_HOST

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying the Kubernetes Dashboard"
echo -e "*******************************************************************************************************************"
tput setaf 3

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard -f ./kubernetes-dashboard/kubernetes-dashboard-values.yaml


tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying ActiveDirectory (ApacheDS)"
echo -e "*******************************************************************************************************************"
tput setaf 3

kubectl apply -f ./apacheds.yaml

while [[ $(kubectl get pods -l app=apacheds -n activedirectory -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for apacheds to be running" && sleep 1; done

