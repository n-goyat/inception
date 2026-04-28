#!/bin/bash
set -e

# Start mysqld in background
mysqld --user=mysql &

MYSQL_PID=$!

# Wait until mysqld is ready
echo "Waiting for MariaDB to start..."
until mysqladmin ping --silent 2>/dev/null; do
    sleep 1
done

echo "MariaDB is ready. Initializing..."

# Initialize only if needed (more robust)
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${WP_NAME}\`;
CREATE USER IF NOT EXISTS '${WP_DBUSER}'@'%' IDENTIFIED BY '${WP_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WP_NAME}\`.* TO '${WP_DBUSER}'@'%';

-- Only set root password if it hasn't been set yet
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}' ;
FLUSH PRIVILEGES;
EOF

echo "Database initialized successfully."

# Keep container running
wait $MYSQL_PID