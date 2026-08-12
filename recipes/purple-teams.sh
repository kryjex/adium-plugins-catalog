#!/bin/bash
# The default make target builds the work variant and the personal variant.
# This recipe supplies the two .so files.
set -euo pipefail

make

cp libteams.so libteams-personal.so "$DIST/"
