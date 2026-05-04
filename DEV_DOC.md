# Developer Documentation

## Prerequisites

- Debian 11 (Bullseye) virtual machine
- Docker Engine and Docker Compose v2
- `make`, `openssl`, `git`, `curl`

Install Docker on a fresh Debian VM:
```
sudo apt install -y curl git make
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

## Environment Setup

1. Clone the repository:
```
(if necessary)
scp -P 2222 -r ~/Circle_05/inception_git/ ngoyat@127.0.0.1:/home/ngoyat/

git clone <repo-url> ~/inception
cd ~/inception
```

2. Create the environment file `srcs/.env`:
```
DOMAIN=ngoyat.42.fr
WP_NAME=
WP_DBUSER=
WP_PASSWORD=
WP_ADMIN_USER=
WP_ADMIN_EMAIL=
WP_ADMIN_PASSWORD=
WP_USER=
WP_EMAIL=
WP_USER_PASSWORD=
DB_ROOT_PASSWORD=
```

3. Add the domain to hosts:
```
echo "127.0.0.1 ngoyat.42.fr" | sudo tee -a /etc/hosts
```

## Building and Launching

```
make
```

Runs in order: data dirs created, certs generated (if missing), images built, containers started.

## Makefile Targets

| Target | Description |
|--------|-------------|
| `make` / `make all` | Full setup |
| `make data` | Create host data directories |
| `make certs` | Generate self-signed TLS cert |
| `make up` | Build images and start containers |
| `make down` | Stop containers |
| `make clean` | Remove containers + volumes |
| `make fclean` | Full clean: containers, volumes, images, host data |
| `make re` | fclean + all |
| `make logs` | Follow container logs |
| `make status` | Show container status |

## Container Management

```
docker compose -f srcs/docker-compose.yml ps
docker exec -it mariadb bash
docker exec -it wp-php bash
docker exec -it nginx bash
```

## Data Storage and Persistence

Persistent data lives on the host at `/home/ngoyat/data/`:

- `/home/ngoyat/data/wordpress/` — WordPress files
- `/home/ngoyat/data/mariadb/` — MariaDB database files

Mounted into containers via named Docker volumes with `driver_opts`. Data survives container restarts and rebuilds. Only `make fclean` or `docker compose down --volumes` removes them.

## Directory Structure

```
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── .gitignore
└── srcs/
    ├── docker-compose.yml
    ├── .env                    (not in git)
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── nginx.conf
        │   └── certs/          (not in git, generated)
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── script.sh
        │   └── www.conf
        └── mariadb/
            ├── Dockerfile
            ├── 50-server.cnf
            └── entrypoint.sh
```
