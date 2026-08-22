#!/bin/bash
# Upstream links libolm + libgcrypt for end-to-end room keys, resolves
# sqlite through pkg-config (keg-only on Homebrew), and expects a
# Debian-style include root (<libpurple/request.h>). The classic nodejs
# http_parser was removed from Homebrew, so it is vendored at build time
# and injected into the link line via LOADLIBES.
set -euo pipefail

brew install libolm libgcrypt sqlite

prefix="$(brew --prefix)"
export PKG_CONFIG_PATH="$prefix/opt/sqlite/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
export CPATH="$PWD/http_parser:$prefix/opt/pidgin/include:${CPATH:-}"
export LIBRARY_PATH="$prefix/opt/libolm/lib:$prefix/opt/libgcrypt/lib:${LIBRARY_PATH:-}"

HTTP_PARSER_TAG=v2.9.4
curl -fsSL "https://github.com/nodejs/http-parser/archive/refs/tags/${HTTP_PARSER_TAG}.tar.gz" \
    -o /tmp/http_parser.tar.gz
rm -rf http_parser
mkdir http_parser
tar xzf /tmp/http_parser.tar.gz -C http_parser --strip-components=1

cc -c http_parser/http_parser.c -o http_parser/http_parser.o

make -j"$(sysctl -n hw.ncpu)" LOADLIBES="http_parser/http_parser.o"

cp libmatrix.so "$DIST/"
