
CERT_DIR=requirements/nginx/certs
DOMAIN=localhost
COMPOSE = ./docker-compose.yml
COMPOSE_CMD = docker compose

.SILENT:

all: print_g build up

build:
	$(COMPOSE_CMD) -f $(COMPOSE) build
	
up:
	$(COMPOSE_CMD) -f $(COMPOSE) up -d

down:
	$(COMPOSE_CMD) -f $(COMPOSE) down

re: down clean build up

clean:
	$(COMPOSE_CMD) -f $(COMPOSE) down --volumes --rmi all --remove-orphans
	docker system prune -f

logs:
	$(COMPOSE_CMD) -f $(COMPOSE) logs -f

certs:
	@mkdir -p $(CERT_DIR)
	@openssl req -x509 -newkey rsa:4096 -sha256 -days 365 \
		-nodes \
		-keyout $(CERT_DIR)/privkey.pem \
		-out $(CERT_DIR)/fullchain.pem \
		-subj "/C=DE/ST=BW/O=42HN/CN=$DOMAIN"

print_g:
	echo " \_____  _______ __   __ _______  ______ _______ __     _ _______ _______"
	echo " |_____] |______   \\_/      |    |_____/ |_____| | \\  | |       |______"
	echo " |       ______|    |       |    |    \\_ |     | |  \\_| |_____  |______"



.PHONY: all build up down clean re logs certs