#!/bin/bash
set -e

cd /var/www/html

# Install WP-CLI if not present
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Wait for MariaDB
until mysqladmin ping -h mariadb -u "${WP_DBUSER}" -p"${WP_PASSWORD}" --silent 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# Download WordPress core
if [ ! -f wp-load.php ]; then
    wp core download --allow-root
fi

# Create wp-config.php
if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname="${WP_NAME}" \
        --dbuser="${WP_DBUSER}" \
        --dbpass="${WP_PASSWORD}" \
        --dbhost="mariadb" \
        --allow-root
fi

# Install WordPress
if ! wp core is-installed --allow-root 2>/dev/null; then
    wp core install \
        --url="https://${DOMAIN}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    # Create second user (non-admin)
    wp user create \
        "${WP_USER}" "${WP_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root
fi

# Start PHP-FPM in foreground
exec php-fpm7.4 -F