
CERT_DIR = srcs/requirements/nginx/certs
DOMAIN   = ngoyat.42.fr
COMPOSE  = docker compose

.SILENT:

all: print_g certs up

# ==================== CERTIFICATES ====================
certs:
	@mkdir -p $(CERT_DIR)
	@openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
		-keyout $(CERT_DIR)/privkey.pem \
		-out $(CERT_DIR)/fullchain.pem \
		-subj "/C=DE/ST=BW/O=42HN/CN=$(DOMAIN)" 2>/dev/null || true
	@echo "✅ Certificates generated for $(DOMAIN)"

# ==================== DOCKER ====================
up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v --remove-orphans

fclean: clean
	$(COMPOSE) down -v --remove-orphans 2>/dev/null || true
	docker system prune -a -f
	sudo rm -rf /home/ngoyat/data 2>/dev/null || true
	@echo "🧹 Full clean done"

re: fclean all

# ==================== UTILS ====================
logs:
	$(COMPOSE) logs -f

status:
	$(COMPOSE) ps

print_g:
	@echo " \_____  _______ __   __ _______  ______ _______ __     _ _______ _______"
	@echo " |_____] |______   \\_/      |    |_____/ |_____| | \\  | |       |______"
	@echo " |       ______|    |       |    |    \\_ |     | |  \\_| |_____  |______"

.PHONY: all certs up down clean fclean re logs status print_g