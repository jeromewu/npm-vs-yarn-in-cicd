#!/bin/sh
#
# Bootstrap Node.js 12 docker image
#

docker run \
  --name nvy-node \
  --rm \
  -it \
  --network nvy-net \
  -v ${PWD}:/src \
  node:12 \
  sh -c "cd /src && bash $1 $2"

