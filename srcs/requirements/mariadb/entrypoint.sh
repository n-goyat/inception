#!/bin/bash
set -e

mysqld --user=mysql &
MYSQL_PID=$!

until mysqladmin ping --silent 2>/dev/null; do
    sleep 1
done

# Only initialize if database doesn't exist yet
if ! mysql -u root -e "USE ${WP_NAME}" 2>/dev/null; then
    echo "First run — initializing database..."
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${WP_NAME}\`;
CREATE USER IF NOT EXISTS '${WP_DBUSER}'@'%' IDENTIFIED BY '${WP_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WP_NAME}\`.* TO '${WP_DBUSER}'@'%';
FLUSH PRIVILEGES;
EOF
fi

wait $MYSQL_PID