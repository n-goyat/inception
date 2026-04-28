#!/bin/bash
set -e

# Start mysqld in background
mysqld --user=mysql &
MYSQL_PID=$!

# Wait until mysqld is ready
until mysqladmin ping --silent 2>/dev/null; do
    sleep 1
done

# Initialize database and user (idempotent)
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${WP_NAME}\`;
CREATE USER IF NOT EXISTS '${WP_DBUSER}'@'%' IDENTIFIED BY '${WP_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WP_NAME}\`.* TO '${WP_DBUSER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Keep container alive by waiting on mysqld foreground
wait $MYSQL_PID