#!/bin/sh
#
# Bootstrap Node.js 12 docker image
#

docker run \
  -it \
  -v ${PWD}:/src \
  node:12 \
  sh -c "cd /src && /bin/bash"
