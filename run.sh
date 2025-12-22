docker run -d \
  --name caddy-gateway \
  --network host \
  --env-file .env \
  -v /etc/ssl/cloudflare:/certs:ro \
  caddy-gateway
