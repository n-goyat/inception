FROM debian:latest

RUN apt update && apt upgrade && apt install -y \
	php-fpm \
	php-mysql \
	php-xml \
	php-curl \
	php-mbstring \
	php-zip \
	php-gd \
	curl \
	vim \
	iputils-ping \
	net-tools \
	&& rm -rf /var/lib/apt/lists/*

COPY www.conf /etc/php/8.2/fpm/pool.d/.

CMD ["php-fpm8.2", "-F"]