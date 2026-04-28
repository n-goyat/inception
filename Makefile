CERT_DIR = srcs/requirements/nginx/certs
DOMAIN   = ngoyat.42.fr
COMPOSE  = docker compose -f srcs/docker-compose.yml

.SILENT:

all: print_g data certs up

# ==================== DATA ====================
data:
	mkdir -p /home/ngoyat/data/wordpress
	mkdir -p /home/ngoyat/data/mariadb

# ==================== CERTIFICATES ====================
certs:
	mkdir -p $(CERT_DIR)
	test -f $(CERT_DIR)/fullchain.pem || openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
		-keyout $(CERT_DIR)/privkey.pem \
		-out $(CERT_DIR)/fullchain.pem \
		-subj "/C=DE/ST=BW/O=42HN/CN=$(DOMAIN)"
	echo "Certificates ready for $(DOMAIN)"

# ==================== DOCKER ====================
up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v --remove-orphans

fclean: clean
	docker system prune -a -f
	docker run --rm -v /home/ngoyat/data:/data debian:bullseye rm -rf /data/wordpress /data/mariadb 2>/dev/null || true
	echo "Full clean done"

re: fclean all

# ==================== UTILS ====================
logs:
	$(COMPOSE) logs -f

status:
	$(COMPOSE) ps

print_g:
	echo "██╗███╗   ██╗ ██████╗███████╗██████╗ ████████╗██╗ ██████╗ ███╗   ██╗"
	echo "██║████╗  ██║██╔════╝██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║"
	echo "██║██╔██╗ ██║██║     █████╗  ██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║"
	echo "██║██║╚██╗██║██║     ██╔══╝  ██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║"
	echo "██║██║ ╚████║╚██████╗███████╗██║        ██║   ██║╚██████╔╝██║ ╚████║"
	echo "╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝"

.PHONY: all data certs up down clean fclean re logs status print_g