FROM docker.io/dunglas/frankenphp:1-alpine
RUN install-php-extensions mysqli exif igbinary imagick zip bcmath gd shmop
RUN apk add --no-cache su-exec
RUN wcurl https://wordpress.org/latest.tar.gz && \
    tar -xf latest.tar.gz && \
    mv wordpress/* public && \
    mv public/wp-content public/_wp-content && \
    rm -rf latest.tar.gz wordpress && \
    chown -R root:www-data public && \
    chmod -R u=rX,g=rX,o= public
COPY docker-php-entrypoint /usr/local/bin
RUN chmod +x /usr/local/bin/docker-php-entrypoint && \
    setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp && \
    chown -R www-data:root /config/caddy /data/caddy && \
    chmod -R u=rwX,g=,o= /config/caddy /data/caddy && \
    mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /usr/local/etc/php/php.ini
ENV SERVER_NAME=:80
