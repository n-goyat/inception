#!/bin/bash

cd /var/www/html

# WP-CLI herunterladen
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Warten bis MariaDB bereit ist
until mysqladmin ping -h mariadb -u "${WP_DBUSER}" -p"${WP_PASSWORD}" --silent 2>/dev/null; do
    echo "Warte auf MariaDB..."
    sleep 2
done

# WordPress Core herunterladen
if [ ! -f wp-load.php ]; then
    wp core download --allow-root
fi

# wp-config.php erstellen
if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname="${WP_NAME}" \
        --dbuser="${WP_DBUSER}" \
        --dbpass="${WP_PASSWORD}" \
        --dbhost="mariadb" \
        --allow-root
fi

# WordPress installieren
if ! wp core is-installed --allow-root 2>/dev/null; then
    wp core install \
        --url="https://${DOMAIN}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create \
        "${WP_USER}" "${WP_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root
fi

php-fpm7.4 -F