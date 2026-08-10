#!/bin/bash
# Build recipe for purple-teams.
# Runs inside the plugin source checkout. Copies the binaries into $DIST.
set -euo pipefail

make

cp libteams.so "$DIST/"
if [ -f libteams-personal.so ]; then
  cp libteams-personal.so "$DIST/"
fi
