#!/bin/bash
# The upstream Makefile is for Linux. On macOS, the Go runtime also needs
# the CoreFoundation framework, the Security framework, and libresolv at
# link time.
set -euo pipefail

brew install go opusfile gdk-pixbuf

CGO_LDFLAGS="$(pkg-config --libs glib-2.0 purple opusfile gdk-pixbuf-2.0) -framework CoreFoundation -framework Security -lresolv"
make libwhatsmeow.so CGO_LDFLAGS="$CGO_LDFLAGS"

cp libwhatsmeow.so "$DIST/"
