*This project has been created as part of the 42 curriculum by ngoyat.*

# Inception

## Description

Inception is a system administration project that sets up a small web infrastructure using Docker and Docker Compose inside a virtual machine. The stack consists of three services — NGINX (reverse proxy with TLS), WordPress with PHP-FPM, and MariaDB — each running in its own container built from scratch using Debian Bullseye. No pre-built images from DockerHub are used.

The infrastructure is designed so that NGINX is the sole entry point via HTTPS (port 443), forwarding PHP requests to WordPress over FastCGI, which in turn communicates with MariaDB over the internal Docker network. Persistent data is stored in named Docker volumes mapped to the host filesystem at `/home/ngoyat/data/`.

## Instructions

### Prerequisites

- Debian 11 (Bullseye) virtual machine
- Docker and Docker Compose v2 installed
- `make`, `openssl`, `git`

### Setup

1. Clone the repository inside the VM:
```
git clone <repo-url> ~/inception
cd ~/inception
```

2. Create the `.env` file in `srcs/` with the required variables (see `DEV_DOC.md`).

3. Add the domain to `/etc/hosts`:
```
echo "127.0.0.1 ngoyat.42.fr" | sudo tee -a /etc/hosts
```

4. Build and start the stack:
```
make
```

5. Open `https://ngoyat.42.fr` in a browser inside the VM and accept the self-signed certificate warning.

## Project Description

### Architecture

The infrastructure follows a three-tier model: NGINX handles TLS termination and serves as a reverse proxy, WordPress + PHP-FPM processes dynamic content, and MariaDB stores the database. All three communicate over an isolated Docker bridge network called `Inception`. Only port 443 is exposed to the host.

### Virtual Machines vs Docker

Virtual machines emulate entire hardware stacks including their own kernel, resulting in higher resource overhead but stronger isolation. Docker containers share the host kernel and only isolate the userspace, making them significantly lighter and faster to start. For this project, Docker runs inside a VM — combining both approaches: the VM provides a controlled environment while Docker manages the individual services efficiently.

### Secrets vs Environment Variables

Environment variables are passed to containers at runtime via the `.env` file and `docker-compose.yml`. They are simple to use but can be inspected via `docker inspect`. Docker Secrets provide a more secure alternative by mounting sensitive data as files inside the container (typically at `/run/secrets/`), making them accessible only to the specific service. For production environments, secrets are the preferred method. This project uses environment variables with the `.env` file excluded from version control via `.gitignore`.

### Docker Network vs Host Network

Host networking removes network isolation — the container shares the host's network stack directly. This is simpler but less secure, as all container ports are directly accessible on the host. Docker bridge networks (used in this project) create an isolated virtual network where containers communicate by container name via DNS resolution, while only explicitly published ports are accessible from outside. The subject explicitly forbids `network: host`.

### Docker Volumes vs Bind Mounts

Bind mounts map a specific host directory into the container, creating a tight coupling between host and container filesystem. Named volumes are managed by Docker and provide better portability and lifecycle management. This project uses named volumes with `driver_opts` configured to store data under `/home/ngoyat/data/`, satisfying the subject requirement while keeping Docker's volume management capabilities.

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress CLI Handbook](https://make.wordpress.org/cli/handbook/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

### AI Usage

AI (Claude by Anthropic) was used as a learning companion during this project for debugging Docker configuration issues, reviewing Dockerfiles and shell scripts for best practices, understanding PID 1 behavior in containers, and clarifying the differences between Docker concepts (volumes vs bind mounts, networks, etc.). All generated content was reviewed, tested, and adapted to fit the project requirements.