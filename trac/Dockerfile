FROM python:3.13-alpine AS base

RUN apk upgrade --no-cache && \
    apk add --no-cache pcre nginx postgresql16-client sqlite curl patch git bash

RUN pip install --upgrade --no-cache-dir setuptools pip wheel build
RUN pip install --no-cache-dir "trac[psycopg2-binary,mysql,babel,pygments,rest,textile] @ git+https://github.com/BtbN/trac.git@8d20df99823cf8655b7be7e87acd7ac569c75262" \
                "git+https://github.com/BtbN/SimpleIrcRelay.git@5b485dbf020e1b628812d1568734d7436dd3e224" \
                TracSensitiveTickets \
                TracAccountManager \
                passlib \
                dnspython \
                pillow \
                filelock


FROM base AS builder

RUN apk add --no-cache build-base linux-headers pcre-dev subversion

RUN pip wheel --no-cache-dir -w /wheels --no-deps \
                uwsgi \
                "svn+https://svn.edgewall.org/repos/trac/plugins/trunk/spam-filter@17866" \
                "git+https://github.com/BtbN/tractags.git@f7c8af2c4c03808e8a5110e8d13ef56256a99387" \
                "git+https://github.com/BtbN/tracvote.git@703f101ecd5d16011e679b2d2e383e3ed4757d17"

# Not compatible with Python 3/Trac 1.6:
#               "svn+https://trac-hacks.org/svn/tracformsplugin/trunk@18659"
#               "svn+https://trac-hacks.org/svn/announcerplugin/trunk@18659"
#               "svn+https://trac-hacks.org/svn/screenshotsplugin/1.2@18659"


FROM base

RUN --mount=from=builder,source=/wheels,target=/wheels pip install --no-cache-dir /wheels/*.whl

RUN --mount=source=.,target=/tmp/files cd /tmp/files && \
    cp run.sh /run.sh && \
    cp update_git.sh /usr/local/bin/update_git.sh && \
    cp nginx.conf /etc/nginx/nginx.conf && \
    cp uwsgi.ini /etc/uwsgi.ini && \
    cp ffmpeg-logo.png /opt/ffmpeg-logo.png

RUN addgroup -g 444 trac && \
    adduser -u 444 -G trac -D trac && \
    chown -R trac:trac /var/lib/nginx
USER trac

VOLUME /home/trac
EXPOSE 8080

ENTRYPOINT ["/run.sh"]
