#!/bin/sh

mkdir -p /run/nginx/
#-g 'daemon off;'
if [ "$*" == "start" ]; then
    flower --version
    flower auto_refresh=false &
    sed "s:FLOWER_URL_PREFIX:${FLOWER_URL_PREFIX}:g" /conf/nginx.conf.tpl > /conf/nginx.conf
    nginx -c /conf/nginx.conf
else
    exec "$@"
fi
