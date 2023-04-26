#!/bin/bash

containers="crystallang/crystal:latest-alpine"

for container in $containers; do
  time docker run --rm -it -v $(pwd):/workspace -w /workspace "$container" bin/build.sh
done
