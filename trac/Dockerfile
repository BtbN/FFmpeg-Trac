FROM python:3.13-alpine AS base

RUN apk upgrade --no-cache && \
    apk add --no-cache pcre nginx postgresql16-client sqlite curl patch git

RUN pip install --upgrade --no-cache-dir setuptools pip wheel build
RUN pip install --no-cache-dir "trac[psycopg2-binary,mysql,babel,pygments,rest,textile] @ git+https://github.com/BtbN/trac.git@3311894991fa86c41b3c6af96c5b571ef0cfcfb8" \
                "git+https://github.com/BtbN/SimpleIrcRelay.git@4466db83e87b2fddde2b2d49c09e3816e4e4b0c0" \
                TracSensitiveTickets \
                TracAccountManager \
                dnspython \
                pillow \
                filelock


FROM base AS builder

RUN apk add --no-cache build-base linux-headers pcre-dev subversion

RUN pip wheel --no-cache-dir -w /wheels --no-deps \
                uwsgi \
                "svn+https://svn.edgewall.org/repos/trac/plugins/trunk/spam-filter@17866" \
                "git+https://github.com/BtbN/tractags.git@299dc7604dfef03fe3110f0aa9f22d0452f27968" \
                "git+https://github.com/BtbN/tracvote.git@703f101ecd5d16011e679b2d2e383e3ed4757d17"

# Not compatible with Python 3/Trac 1.6:
#               "svn+https://trac-hacks.org/svn/tracformsplugin/trunk@18659"
#               "svn+https://trac-hacks.org/svn/announcerplugin/trunk@18659"
#               "svn+https://trac-hacks.org/svn/screenshotsplugin/1.2@18659"


FROM base

RUN --mount=from=builder,source=/wheels,target=/wheels pip install --no-cache-dir /wheels/*.whl

RUN --mount=source=.,target=/tmp/files cd /tmp/files && \
    cp run.sh /run.sh && \
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
