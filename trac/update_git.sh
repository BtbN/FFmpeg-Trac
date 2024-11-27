#!/bin/bash
set -xeo pipefail

if [ -z "$GIT_REPO_URL" ]; then
    echo "No repo set"
    exit 1
fi

if [ -z "$GIT_REPO_NAME" ]; then
    echo "No repo name set"
    exit 1
fi

mkdir -p /home/trac/git
if ! [ -d "/home/trac/git/$GIT_REPO_NAME" ]; then
    git clone "$GIT_REPO_URL" "/home/trac/git/$GIT_REPO_NAME"
fi

cd "/home/trac/git/$GIT_REPO_NAME"
git remote set-url origin "$GIT_REPO_URL"

while true; do
    sleep 60
    git fetch origin "${GIT_REPO_BRANCH:-master}" || continue
    OHEAD="$(git rev-parse @)"
    NHEAD="$(git rev-parse FETCH_HEAD)"
    if [ "$OHEAD" != "$NHEAD" ]; then
        git rev-list --reverse "${OHEAD}..${NHEAD}" -- | xargs trac-admin /home/trac/env changeset added "$GIT_REPO_NAME"
        git reset --hard "$NHEAD"
    fi
done
