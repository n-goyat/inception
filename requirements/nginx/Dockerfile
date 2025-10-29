
FROM debian:bullseye

RUN apt update && apt upgrade && apt install -y \
	nginx \
	curl \
	vim \
	iputils-ping \
	net-tools \
	&& rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf:ro
# COPY /etc/nginx/sites-enabled/.

RUN openssl req \
		-x509 \
		-nodes \
		-days 365 \
		-newkey rsa:2048 \
		-keyout /etc/ssl/private/nginx-selfsigned.key \
		-out /etc/ssl/certs/nginx-selfsigned.crt \
		-subj "/C=DE/ST=BW/O=42HN/CN=$DOMAIN"


CMD ["nginx", "-g", "daemon off;"]