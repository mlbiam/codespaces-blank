#!/bin/bash

echo '{"ip6tables": false}' > /etc/docker/daemon.json
DOCKER_PS=$(ps aux | grep dockerd | grep dns | awk '{print $2}')
kill -SIGINT $DOCKER_PS
echo "sleeping 10 seconds to wait for docker to be down"
sleep 10s
dockerd --dns 168.63.129.16 &

echo "Sleeping 30 seconds for docker to be running"
sleep 10s
echo "Deploying KinD"