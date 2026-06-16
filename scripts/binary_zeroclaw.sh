#!/bin/sh

case $1 in
  amd64)
    VARIANT=x86_64-unknown-linux-gnu
    ;;

  arm64)
    VARIANT=aarch64-unknown-linux-gnu
    ;;

  *)
    echo "Unsupported architecture: $1" >&2
    exit 1
    ;;
esac

mv "./zeroclaw-${VARIANT}/zeroclaw" ./zeroclaw
mv "./web-dist-${VARIANT}" ./web-dist
