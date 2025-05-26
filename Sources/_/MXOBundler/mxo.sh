#!/usr/bin/env bash
# $1 = path to libName.dylib
# $2 = path to output Name.mxo
set -e
mkdir -p "$2/Contents/MacOS"
cp "$1" "$2/Contents/MacOS/$(basename "$2")"
