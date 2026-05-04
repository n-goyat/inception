# User Documentation

## Services Overview

This stack provides a fully functional WordPress website served over HTTPS. It consists of three services:

- **NGINX** — handles incoming HTTPS connections on port 443 and forwards PHP requests to WordPress
- **WordPress + PHP-FPM** — serves the WordPress application
- **MariaDB** — stores all WordPress data (posts, users, settings)

## Connecting to the VM

```
ssh ngoyat@127.0.0.1 -p 2222
```

## Starting and Stopping

Start all services:
```
make
```

Stop all services (data preserved):
```
make down
```

Full clean restart:
```
make re
```

View live logs:
```
make logs
```

## Accessing the Website

From within the VM, verify the site is running:
```
curl -k https://ngoyat.42.fr
```

In a browser inside the VM, navigate to:
```
https://ngoyat.42.fr
```

Accept the self-signed certificate warning to proceed.

## Administration Panel

Access the WordPress admin dashboard at:
```
https://ngoyat.42.fr/wp-admin
```

Log in with the administrator credentials defined in `srcs/.env` (variables `WP_ADMIN_USER` and `WP_ADMIN_PASSWORD`). The admin username does not contain "admin" or "Admin" as required by the subject.

A second non-admin user is also available (defined by `WP_USER` and `WP_USER_PASSWORD`) for testing comments and regular user functionality.

## Credentials

All credentials are stored in `srcs/.env`, excluded from version control via `.gitignore`. This file must be created manually during setup and contains database passwords, WordPress admin credentials, and the domain name.

Never commit the `.env` file to git.

## Verifying Services

Check that all containers are running:
```
docker compose -f srcs/docker-compose.yml ps
```

All three containers (nginx, wp-php, mariadb) should show status `Up`.

Verify the TLS protocol used:
```
openssl s_client -connect ngoyat.42.fr:443 2>/dev/null | grep -E "Protocol|Cipher"
```

Verify the database is accessible and not empty:
```
docker exec mariadb mysql -u wpuser -password wordpress -e "SHOW TABLES;"
```

Verify volumes point to `/home/ngoyat/data/`:
```
docker volume inspect srcs_wordpress_data
docker volume inspect srcs_mariadb_data
```

Verify HTTP is not accessible (should fail):
```
curl http://ngoyat.42.fr
```

Verify WordPress posts (persistence test):
```
docker exec wp-php /usr/local/bin/wp post list --path=/var/www/html --allow-root
```

Login to the database directly:
```
docker exec -it mariadb mysql -u wpuser -password wordpress
```

## Persistence Test

To verify data persists across reboots:

1. Create a test post:
```
docker exec wp-php /usr/local/bin/wp post create \
    --post_title="Persistence Test" \
    --post_status=publish \
    --path=/var/www/html \
    --allow-root
```

2. Reboot the VM:
```
sudo reboot
```

3. Reconnect via SSH and restart:
```
ssh ngoyat@127.0.0.1 -p 2222
cd ~/inception
make
```

4. Verify the post is still there:
```
docker exec wp-php /usr/local/bin/wp post list --path=/var/www/html --allow-root
```