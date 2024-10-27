#!/bin/sh
cd "$(dirname "$0")"
docker compose pull || exit $?
docker compose build --pull || exit $?
docker compose up -d
