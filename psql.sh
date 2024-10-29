#!/bin/bash
set -e
test -f .env && source .env
POSTGRES_USER="${POSTGRES_USER:-trac}"
exec docker compose exec -ti db psql -U trac
