# Inception

A Docker-based infrastructure project for 42 School.

## Architecture
Browser (HTTPS:443)
↓
nginx (reverse proxy + TLS termination)
↓ FastCGI :9000
WordPress + PHP-FPM
↓ TCP :3306
MariaDB

## Services

- **nginx** — reverse proxy, serves HTTPS only (TLSv1.3), self-signed certificate
- **wordpress** — PHP-FPM, installed via WP-CLI at runtime
- **mariadb** — database backend, not exposed externally

## Requirements

- Docker + Docker Compose
- make
- openssl (for certificate generation)

## Setup

1. Clone the repository into `~/data/inception` (or your VM's home directory)
2. Create a `.env` file:

```env
DOMAIN=ngoyat.42.fr
WP_NAME=wordpress
WP_DBUSER=wpuser
WP_PASSWORD=wppass123
WP_ADMIN_USER=admin
WP_ADMIN_EMAIL=admin@ngoyat.42.fr
WP_ADMIN_PASSWORD=adminpass123
WP_USER=nate
WP_EMAIL=user@ngoyat.42.fr
WP_USER_PASSWORD=userpass123
DB_ROOT_PASSWORD=rootpass123
```

3. Add domain to `/etc/hosts`:
```bash
echo "127.0.0.1 ngoyat.42.fr" | sudo tee -a /etc/hosts
```

4. Generate TLS certificates and start:
```bash
make certs
make
```

5. Open `https://ngoyat.42.fr` in your browser and accept the self-signed certificate warning.

## Makefile targets

| Target | Description |
|--------|-------------|
| `make` / `make all` | Build and start all containers |
| `make build` | Build images |
| `make up` | Start containers |
| `make down` | Stop containers |
| `make re` | Full rebuild |
| `make clean` | Remove containers, volumes, images |
| `make logs` | Follow logs |
| `make certs` | Generate self-signed TLS certificate |

## Notes

- MariaDB is not exposed externally — only reachable within the Docker network
- WordPress is installed automatically on first start via WP-CLI
- Data persists in named Docker volumes (`wordpress_data`, `mariadb_data`)
- All containers are built from `debian:bullseye` — no pre-built images used

## Description
This project consists of setting up a small infrastructure composed of different
services using Docker and Docker Compose. Each service runs in a dedicated container
built from scratch using Debian Bullseye.

The infrastructure includes:
- An nginx container with TLSv1.3 as the sole entry point (port 443)
- A WordPress + PHP-FPM container configured via WP-CLI
- A MariaDB container for the WordPress database

Containers communicate over a dedicated Docker bridge network. Persistent data
is stored in named volumes for both the database and WordPress files.
No pre-built images (e.g. from Docker Hub) are used — all images are built
from custom Dockerfiles.