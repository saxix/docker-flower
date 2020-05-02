#!/bin/sh

mkdir -p /run/nginx/
#-g 'daemon off;'
if [ "$*" == "start" ]; then
    flower --version
    flower auto_refresh=false &
    if [ -z "$FLOWER_URL_PREFIX" ]; then
      TEMPLATE='/conf/nginx.prefix.conf.tpl';
    else
      TEMPLATE='/conf/nginx.conf.tpl'
    fi
    sed "s:FLOWER_URL_PREFIX:${FLOWER_URL_PREFIX}:g" TEMPLATE > /conf/nginx.conf
    sed -i "s:SERVER_NAME:${SERVER_NAME}:g" /conf/nginx.conf
    sed -i "s:SERVER_PORT:${SERVER_PORT}:g" /conf/nginx.conf

    nginx -c /conf/nginx.conf
else
    exec "$@"
fi
