#!/bin/bash
set -e
cd "$(dirname "$0")"

./build.sh

mkdir -p home
docker run --rm -v "$PWD/home:/home/trac:z" -u root ffmpeg_trac:latest sh -c "chown -R trac:trac /home/trac"
docker run --rm -ti -v "$PWD/home:/home/trac:z" ffmpeg_trac:latest init
