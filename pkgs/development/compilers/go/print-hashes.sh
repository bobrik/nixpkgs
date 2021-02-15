#!/usr/bin/env bash
set -euo pipefail

PLATFORMS=(
    darwin-amd64
    linux-arm64
    linux-armv6l
    linux-amd64
    linux-386
    linux-ppc64le
)
BASEURL=https://golang.org/dl/
VERSION=${1:-}

if [[ -z $VERSION ]]
then
    echo "No version supplied"
    exit -1
fi

for PLATFORM in "${PLATFORMS[@]}"
do
    URL="$BASEURL/go$VERSION.$PLATFORM.tar.gz"
    SHA256=$(curl -sSfL $URL | shasum -a 256 | cut -d ' ' -f 1)
    echo "$PLATFORM = \"$SHA256\";"
done
