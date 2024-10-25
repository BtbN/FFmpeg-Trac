#!/bin/sh
TGT="$(realpath "$1")"
cd "$(dirname "$0")"

if [ "$#" != 1 ]; then
	echo "Invalid arguments"
	exit 1
fi

./build.sh || exit $?

docker run --rm -v "$PWD/home:/home/trac" -v "${TGT}:/bak" -u root ffmpeg_trac:latest sh -c "chown trac:trac /bak"
docker run --rm -v "$PWD/home:/home/trac" -v "${TGT}:/bak" -u trac ffmpeg_trac:latest sh -c "trac-admin /home/trac/env hotcopy '/bak/${2:-trac_backup}'"
