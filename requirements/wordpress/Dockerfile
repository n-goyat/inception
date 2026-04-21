FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y \
    php-fpm \
    php-mysql \
    php-xml \
    php-curl \
    php-mbstring \
    php-zip \
    php-gd \
    default-mysql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY script.sh /script.sh
RUN chmod +x /script.sh
RUN mkdir -p /run/php/

CMD ["/script.sh"]