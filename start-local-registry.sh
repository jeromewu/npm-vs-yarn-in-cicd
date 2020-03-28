#!/bin/sh

docker network create nvy-net
docker run \
  --name nvy-registry \
  -d \
  --rm \
  --network nvy-net \
  verdaccio/verdaccio:4.5.1

