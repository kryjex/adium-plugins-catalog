#!/bin/bash
# The upstream Makefile targets Linux. On macOS the plain make build works
# once libolm is present: purple-matrix links it for end-to-end room keys.
set -euo pipefail

brew install libolm

make -j"$(sysctl -n hw.ncpu)"

cp libmatrix.so "$DIST/"
