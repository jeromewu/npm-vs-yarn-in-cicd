#!/bin/bash

CASE=$1

for cmd in npm-install npm-ci yarn-install yarn-install-frozen-lockfile
do
  bash docker-run.sh do-run.sh c${CASE}-${cmd}
done

