ARG NGINX_TAG="1.17.3-alpine"

FROM nginx:${NGINX_TAG} AS install

ENV INSTALL_ROOT /install

RUN mkdir -p ${INSTALL_ROOT}/usr/sbin
RUN cp /usr/sbin/nginx ${INSTALL_ROOT}/usr/sbin/nginx

RUN mkdir -p ${INSTALL_ROOT}/etc/nginx
RUN cp /etc/nginx/mime.types ${INSTALL_ROOT}/etc/nginx/mime.types

RUN mkdir -p ${INSTALL_ROOT}/config

COPY docker/nginx.conf ${INSTALL_ROOT}/etc/nginx/nginx.conf
COPY docker/config ${INSTALL_ROOT}/config
COPY docker/entrypoint ${INSTALL_ROOT}/entrypoint

RUN chmod 0755 ${INSTALL_ROOT}/entrypoint
RUN chown -R root:root ${INSTALL_ROOT}

FROM alpine:3.10 AS base

COPY --from=install /install /

RUN set -ex \
  ; apk add pcre \
  ; mkdir -p /var/log/nginx \
  ; chmod 0751 /var/log/nginx \
  ; ln -s /dev/stderr /var/log/nginx/error.log \
  ; addgroup -g 1000 nginx \
  ; adduser -H -D -u 1000 -h /etc/nginx -s /bin/sh -G nginx -g nginx nginx

USER nginx
EXPOSE 8000-8001
STOPSIGNAL SIGTERM
VOLUME ["/content"]
ENTRYPOINT ["/entrypoint"]
CMD ["nginx"]
