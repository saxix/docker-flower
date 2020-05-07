#!/bin/sh

mkdir -p /run/nginx/

doconfig(){
    sed "s:FLOWER_URL_PREFIX:${FLOWER_URL_PREFIX}:g" $TEMPLATE > /conf/nginx.conf
    sed -i "s:SERVER_NAME:${SERVER_NAME}:g" /conf/nginx.conf
    sed -i "s:SERVER_PORT:${SERVER_PORT}:g" /conf/nginx.conf
    sed -i "s:FLOWER_ADDRESS:${FLOWER_ADDRESS}:g" /conf/nginx.conf
}

if [ -z "$FLOWER_URL_PREFIX" ]; then
  TEMPLATE='/conf/nginx.conf.tpl'
else
  TEMPLATE='/conf/nginx.prefix.conf.tpl';
fi

if [ "$*" = "config" ]; then
  doconfig
  cat /conf/nginx.conf
elif [ "$*" = "start" ]; then
    doconfig
    flower --version
    flower auto_refresh=false &
    nginx -c /conf/nginx.conf
else
    exec "$@"
fi
