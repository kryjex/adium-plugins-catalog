#!/bin/bash
# Build recipe for purple-gowhatsapp (whatsmeow).
# Runs inside the plugin source checkout. Copies the binary into $DIST.
set -euo pipefail

brew install go opusfile gdk-pixbuf

CGO_LDFLAGS="$(pkg-config --libs glib-2.0 purple opusfile gdk-pixbuf-2.0) -framework CoreFoundation -framework Security -lresolv"
make libwhatsmeow.so CGO_LDFLAGS="$CGO_LDFLAGS"

cp libwhatsmeow.so "$DIST/"
