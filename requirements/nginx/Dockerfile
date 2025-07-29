
FROM debian:bullseye

RUN apt update && apt upgrade && apt install -y \
	nginx \
	curl \
	vim \
	iputils-ping \
	net-tools \
	&& rm -rf /var/lib/apt/lists/*

COPY default /etc/nginx/sites-available/.

CMD ["nginx", "-g", "daemon off;"]