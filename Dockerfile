FROM alpine:3.8

RUN mkdir -p /run/nginx/ /run/php-fpm/ /app/public/
RUN apk --update --no-cache add argon2 argon2-dev curl supervisor \
    nginx php7-cli php7-bcmath php7-ctype php7-fpm php7-json php7-mbstring \
    php7-openssl php7-pdo php7-pdo_pgsql php7-pgsql php7-tokenizer \
    php7-xml php7-redis openssl openssl-dev
RUN curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux && chmod +x /usr/local/bin/ep

COPY config/configure.sh /etc/configure.sh
COPY config/supervisor.conf /etc/supervisor.conf
COPY config/nginx.conf.tpl /etc/nginx/nginx.conf.tpl
COPY config/php.conf.tpl /etc/php7/php-fpm.d/www.conf.tpl
RUN cp /etc/nginx/nginx.conf.tpl /etc/nginx/nginx.conf && cp /etc/php7/php-fpm.d/www.conf.tpl /etc/php7/php-fpm.d/www.conf && \
    chmod +x /etc/configure.sh && touch /app/pre_start.sh && chmod +x /app/pre_start.sh
COPY VERSION /etc/VERSION
EXPOSE 8080
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor.conf"]
