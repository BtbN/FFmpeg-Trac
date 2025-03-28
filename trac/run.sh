#!/bin/sh

if [ "$1" = "init" ]; then
    if ! [ -d /home/trac/env ]; then
        trac-admin /home/trac/env initenv || exit $?
    fi
    rm -rf /home/trac/deploy
    trac-admin /home/trac/env deploy /home/trac/deploy
elif [ "$1" = "nginx" ]; then
    shift
    exec nginx -e stderr "$@"
elif [ "$1" = "uwsgi" ]; then
    shift
    exec uwsgi --ini /etc/uwsgi.ini "$@"
elif [ "$1" = "ircbot" ]; then
    shift
    export PYTHONUNBUFFERED=1
    exec simpleircrelay "$@"
elif [ "$1" = "update_git" ]; then
    shift
    exec update_git.sh "$@"
elif [ "$1" = "sh" ]; then
    shift
    exec sh "$@"
else
    echo "No mode: init, nginx, uwsgi, ircbot, update_git, sh"
    exit 1
fi
