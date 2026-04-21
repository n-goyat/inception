#!/bin/bash

mysqld --user=mysql &
MYSQL_PID=$!

# Warten bis mysqld bereit ist
until mysqladmin ping --silent 2>/dev/null; do
    sleep 1
done

mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${WP_NAME}\`;
CREATE USER IF NOT EXISTS '${WP_DBUSER}'@'%' IDENTIFIED BY '${WP_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WP_NAME}\`.* TO '${WP_DBUSER}'@'%';
FLUSH PRIVILEGES;
EOF

wait $MYSQL_PID

#Das Bash-Script startet mysqld im Hintergrund, wartet kurz, 
#führt dann mysql aus. Zu diesem Zeitpunkt sind die Env-Variablen aus docker-compose 
#bereits in der Shell verfügbar und werden korrekt eingesetzt.