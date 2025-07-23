
FROM debian:latest

RUN apt update && apt upgrade && apt install -y \
	nginx \
	curl \
	vim \
	iputils-ping \
	net-tools \
	&& rm -rf /var/lib/apt/lists/*

	CMD ["nginx", "-g", "daemon off;"]