#!/bin/bash
# Builds the manylinux_2_28 x86_64 wheel into dist/.
# PYTHON_TAG selects a manylinux /opt/python interpreter (default cp314-cp314).
set -euo pipefail

PYTHON_TAG="${PYTHON_TAG:-cp314-cp314}"

# 1. Build the builder image
docker build -t piranha-builder -f builder.Dockerfile --build-arg PYTHON_TAG="$PYTHON_TAG" .

# 2. Run the container and mount the dist folder to get the wheel out
mkdir -p dist
docker run --rm -v "$(pwd)/dist:/src/dist" piranha-builder
