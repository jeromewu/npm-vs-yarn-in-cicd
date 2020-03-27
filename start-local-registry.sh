#!/bin/sh

docker network create nvy-net
docker run \
  --name nvy-registry \
  -d \
  --rm \
  --network nvy-net \
  -v ${PWD}/registry-storage:/verdaccio/storage \
  verdaccio/verdaccio:4.5.1

