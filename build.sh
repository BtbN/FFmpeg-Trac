#!/bin/bash
set -e
cd "$(dirname "$0")"
docker build -t ffmpeg_trac:latest trac
