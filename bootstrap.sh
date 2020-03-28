#!/bin/bash

echo "Step 1: Stop local registry if started"
bash stop-local-registry.sh
echo "Step 2: Start local registry"
bash start-local-registry.sh
echo "Step 3: Run a single installation to generate cache in local registry, node_modules.tar.gz and cache.tar.gz"
bash docker-run.sh do-run.sh c0
echo "Done! Now we can start the experiment"
