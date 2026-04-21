FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y \
    nginx \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/nginx/sites-enabled/default \
    && rm -f /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/inception.conf

CMD ["nginx", "-g", "daemon off;"]