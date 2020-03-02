#!/bin/bash

echo "starting mongodb"
nohup /usr/local/bin/docker-entrypoint.sh mongod > ${HOME}/logs/mongodb.log &
until mongo --eval "db.serverStatus()" >/dev/null 2>&1; do
        echo "waiting for mongodb..."
        sleep 1
done
echo "mongodb is up"

echo "starting node"
nohup node --max-old-space-size=16384 ${HOME}/Tdarr/bundle/main.js > ${HOME}/logs/tdarr.log &
until curl -s ${HOSTNAME}:${PORT} | grep Tdarr >/dev/null 2>&1; do
        echo "waiting for node..."
        sleep 1
done
echo "node is up"
tail -f ${HOME}/logs/tdarr.log
