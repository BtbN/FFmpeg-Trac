FROM python:3.13-alpine AS builder

RUN apk upgrade --no-cache && \
    apk add --no-cache build-base linux-headers pcre-dev subversion
RUN pip install --upgrade --no-cache-dir setuptools pip wheel build

RUN pip wheel --no-cache-dir -w /wheels --no-deps \
                uwsgi \
                "svn+https://svn.edgewall.org/repos/trac/plugins/trunk/spam-filter"


FROM python:3.13-alpine

RUN apk upgrade --no-cache && \
    apk add --no-cache nginx pcre

RUN pip install --upgrade --no-cache-dir setuptools pip
RUN pip install --no-cache-dir "trac[mysql,babel,pygments,rest,textile]==1.6" \
                TracTags \
                TracVote \
                TracSensitiveTickets \
                TracAccountManager

RUN --mount=from=builder,source=/wheels,target=/wheels pip install --no-cache-dir /wheels/*.whl

COPY run.sh /run.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY uwsgi.ini /etc/uwsgi.ini

RUN addgroup -g 444 trac && \
    adduser -u 444 -G trac -D trac && \
    chown -R trac:trac /var/lib/nginx
USER trac

VOLUME /home/trac
EXPOSE 8080

ENTRYPOINT ["/run.sh"]
