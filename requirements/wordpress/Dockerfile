FROM debian:bullseye

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

COPY www.conf /etc/php/7.4/fpm/pool.d/.
COPY script.sh .
RUN chmod +x script.sh
# RUN mkdir /run/php/php7.4-fpm.pid
RUN mkdir /run/php/


CMD ["./script.sh"]