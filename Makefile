
CERT_DIR=requirements/nginx/certs
DOMAIN=localhost
COMPOSE = ./docker-compose.yml

.SILENT:

all: print_g build up

build:
	docker-compose -f $(COMPOSE) build
	
up:
	docker-compose -f $(COMPOSE) up -d

down:
	docker-compose -f $(COMPOSE) down

re: down clean build up

clean:
	docker-compose -f $(COMPOSE) down --volumes --rmi all --remove-orphans
	docker system prune -f

logs:
	docker-compose -f $(COMPOSE) logs -f

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



.PHONY: all build up down clean