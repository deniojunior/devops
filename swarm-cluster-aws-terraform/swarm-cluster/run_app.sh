#!/bin/bash

cd python_app
docker build . -t pyapp
docker service create --replicas 3 -p 80:8080 pyapp
curl localhost/status