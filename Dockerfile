FROM python:3.8.8-alpine3.12

ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST
ENV PIP_INDEX_URL=$PIP_INDEX_URL
ENV PIP_TRUSTED_HOST=$PIP_TRUSTED_HOST
ENV CRYPTOGRAPHY_DONT_BUILD_RUST 1
USER root

#ENV FLOWER_OAUTH2_VALIDATE ""
ENV FLOWER_AUTH_PROVIDER "flower_oauth_azure.tenant.AzureTenantLoginHandler"
ENV FLOWER_OAUTH2_VALIDATE "1"
ENV FLOWER_DEBUG "0"
ENV FLOWER_PORT	"5555"
#ENV FLOWER_OAUTH2_TENANT ""
#ENV FLOWER_OAUTH2_KEY ""
#ENV FLOWER_OAUTH2_SECRET ""
#ENV FLOWER_AUTH ""

ENV SERVER_NAME="flower" \
    SERVER_PORT="8000" \
    FLOWER_ADDRESS="127.0.0.1" \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    linux-headers \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python3-dev

RUN apk add --no-cache \
    bash \
    ca-certificates \
    su-exec \
    nginx \
    sed \
    && update-ca-certificates

RUN pip install --no-cache-dir \
        redis \
        tornado==5.1.1 \
        flower==0.9.7 \
        flower-oauth-azure[verification]==1.0


RUN apk del .build-deps \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh
COPY conf/ /conf
COPY VERSION /
RUN chmod +x /entrypoint.sh \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log


EXPOSE 5555
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]
