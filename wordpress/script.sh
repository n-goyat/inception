#!/bin/bash

# Wechsel ins WordPress-Volume-Verzeichnis
cd /var/www/html

# WP-CLI herunterladen, falls noch nicht vorhanden
if [ ! -f wp-cli.phar ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
fi

# WordPress Core herunterladen
./wp-cli.phar core download --allow-root

# WordPress konfigurieren
./wp-cli.phar config create \
    --dbname="${WP_NAME}" \
    --dbuser="${WP_DBUSER}" \
    --dbpass="${WP_PASSWORD}" \
    --dbhost="mariadb" \
    --allow-root

# WordPress installieren
./wp-cli.phar core install \
    --url="http://localhost:8080" \
    --title="Inception" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root

# PHP-FPM starten (Foreground)
php-fpm7.4 -F