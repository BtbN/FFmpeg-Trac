#!/bin/bash
set -e

if [ "$#" != 1 ]; then
	echo "Invalid arguments"
	exit 1
fi

BKNAME="${1}"
cd "$(dirname "$0")"

docker compose exec trac sh -c "trac-admin /home/trac/env hotcopy '/home/trac/backup/$BKNAME' --no-database"

test -f .env && source .env
POSTGRES_USER="${POSTGRES_USER:-trac}"
POSTGRES_DB="${POSTGRES_DB:-trac}"
POSTGRES_SCHEMA="${POSTGRES_SCHEMA:-trac}"

docker compose exec db pg_dump -C --inserts -x -Z 8 -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -n "${POSTGRES_SCHEMA}" -p 5432 > "${TGT}/${BKNAME}"/db/postgres-db-backup.sql.gz
