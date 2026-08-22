#!/bin/bash
# Upstream links libolm + libgcrypt for end-to-end room keys and
# http_parser for the API layer. Its sources also expect a Debian-style
# include root (<libpurple/request.h>), so the recipe exposes the Homebrew
# include and library roots through CPATH/LIBRARY_PATH instead of
# patching the Makefile.
set -euo pipefail

brew install libolm libgcrypt http-parser sqlite

prefix="$(brew --prefix)"
export PKG_CONFIG_PATH="$prefix/opt/sqlite/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
export CPATH="$prefix/opt/pidgin/include:$prefix/opt/http-parser/include:${CPATH:-}"
export LIBRARY_PATH="$prefix/opt/http-parser/lib:$prefix/opt/libolm/lib:$prefix/opt/libgcrypt/lib:${LIBRARY_PATH:-}"

make -j"$(sysctl -n hw.ncpu)"

cp libmatrix.so "$DIST/"
