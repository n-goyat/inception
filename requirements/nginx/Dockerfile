
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


CMD ["nginx", "-g", "daemon off;"]