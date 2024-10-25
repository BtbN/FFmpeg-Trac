#!/bin/sh
cd "$(dirname "$0")"

./build.sh || exit $?

mkdir -p home
docker run --rm -v "$PWD/home:/home/trac" -u root ffmpeg_trac:latest sh -c "chown -R trac:trac /home/trac"
docker run --rm -ti -v "$PWD/home:/home/trac" ffmpeg_trac:latest init
