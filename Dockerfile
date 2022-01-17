FROM alpine:3.15
LABEL maintainer="Aristo Rinjuang <aristorinjuang@gmail.com>" \
      description="Lightweight Pimcore, Lumen, or Laravel image with Nginx 1.18, PHP-FPM 7.4, Composer 2, and Supercronic (Cron) based on Alpine Linux."

ENV TZ="Asia/Jakarta"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "https://nl.alpinelinux.org/alpine/v3.15/main" >> /etc/apk/repositories
RUN echo "https://nl.alpinelinux.org/alpine/v3.15/community" >> /etc/apk/repositories

RUN apk --no-cache add busybox-extras vim mysql-client lftp gettext supervisor openssl tzdata nginx curl

RUN apk --no-cache add php7 php7-cli php7-fpm php7-mysqli php7-json php7-openssl php7-curl php7-ftp \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-session \
    php7-mbstring php7-gd php7-redis php7-opcache php7-iconv php7-zip php7-xmlwriter php7-pdo \
    php7-soap php7-pdo_mysql php7-tokenizer php7-fileinfo php7-simplexml php7-exif

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --2 \
    && rm -rf /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

ENV SUPERCRONIC_URL="https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64" \
    SUPERCRONIC="supercronic-linux-amd64" \
    SUPERCRONIC_SHA1SUM="048b95b48b708983effb2e5c935a1ef8483d9e3e"
RUN curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic