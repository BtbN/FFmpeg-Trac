#!/bin/sh
cd "$(dirname "$0")"
docker compose build --pull || exit $?
docker compose up -d
