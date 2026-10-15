#!/bin/sh
set -eu

docker compose exec caddy caddy reload \
  --config /etc/caddy/Caddyfile \
  --adapter caddyfile