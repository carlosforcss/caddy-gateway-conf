#!/bin/sh
set -eu

docker compose exec --no-TTY caddy caddy reload \
  --config - \
  --adapter caddyfile < Caddyfile