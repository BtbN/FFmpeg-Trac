#!/bin/bash
set -e

if [ "$#" != 1 ]; then
	echo "Invalid arguments"
	exit 1
fi

cd "$(dirname "$0")"

docker compose exec trac sh -c "trac-admin /home/trac/env hotcopy '/home/trac/backup/$1'"
