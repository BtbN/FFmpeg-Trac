FROM python:3.13-alpine AS builder

RUN apk upgrade --no-cache && \
    apk add --no-cache build-base linux-headers
RUN pip install --upgrade --no-cache-dir setuptools pip wheel build

RUN pip wheel --no-cache-dir -w /wheels uwsgi


FROM python:3.13-alpine

RUN apk upgrade --no-cache && \
    apk add --no-cache nginx

RUN pip install --upgrade --no-cache-dir setuptools pip && \
    pip install --no-cache-dir "trac[psycopg2-binary,mysql,babel,pygments,rest,textile]==1.6"

RUN --mount=from=builder,source=/wheels,target=/wheels pip install --no-cache-dir /wheels/*.whl

COPY run.sh /run.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY uwsgi.ini /etc/uwsgi.ini

RUN addgroup -g 444 trac && \
    adduser -u 444 -G trac -D trac && \
    chown -R trac:trac /var/lib/nginx
USER trac

VOLUME /home/trac
EXPOSE 8080 3031

ENTRYPOINT ["/run.sh"]
