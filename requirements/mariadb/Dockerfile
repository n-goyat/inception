FROM debian:bullseye

RUN apt update && apt upgrade && apt install -y \
	mariadb-server \
	mariadb-client \
	curl \
	vim \
	iputils-ping \
	net-tools \
	&& rm -rf /var/lib/apt/lists/*

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY init.sql /etc/mysql/init.sql


RUN mkdir /run/mysqld

CMD ["mysqld"]