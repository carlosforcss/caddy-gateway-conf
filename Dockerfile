FROM caddy:2.8-alpine

COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 443/tcp
EXPOSE 443/udp