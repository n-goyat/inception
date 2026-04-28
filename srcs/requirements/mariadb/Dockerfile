FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y \
    mariadb-server \
    mariadb-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]