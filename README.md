# Caddy gateway

Caddy terminates TLS for `carlostoolkit.com` and proxies its subdomains to services running on the host.

## Requirements

- Docker Engine with Docker Compose
- A Cloudflare origin certificate and private key
- TCP and UDP port `443` available on the host
- The upstream services from `Caddyfile` listening on the host ports they declare

The stack uses host networking because the upstreams bind to `127.0.0.1`. It works directly on Linux. On Docker Desktop, enable **Settings → Resources → Network → Enable host networking** first.

## Configure

```sh
cp .env.example .env
```

Set these values in `.env`:

- `TLS_CERTS_DIR`: host directory containing the certificate files.
- `TLS_CERT`: certificate path inside the container, below `/certs`.
- `TLS_KEY`: private-key path inside the container, below `/certs`.
- `CADDY_IMAGE`: optional image name; defaults to `caddy-gateway:local`.

The certificate directory is mounted read-only. Caddy state is retained in the `caddy_data` and `caddy_config` named volumes.

## Run

```sh
./run.sh
```

`run.sh` builds the image, starts the stack, and waits for its health check. Equivalent Compose commands:

```sh
docker compose up --detach --build --wait
docker compose ps
docker compose logs --follow caddy
```

## Change the proxy configuration

`Caddyfile` is mounted read-only into the container. The commands stream the
working-tree file over stdin so a `git pull` that replaces the host file's inode
does not leave Caddy validating and reloading the stale bind-mounted inode:

```sh
docker compose exec --no-TTY caddy caddy validate \
  --config - \
  --adapter caddyfile < Caddyfile
./reload.sh
```

A failed validation or reload leaves the running configuration in place.

## Operate

```sh
./build.sh                 # build the image
./reload.sh                # reload a validated Caddyfile
docker compose restart     # restart Caddy
docker compose down        # stop and remove the container
docker compose down -v     # also delete Caddy's persisted state
```

The container filesystem is read-only except for `/data`, `/config`, and a small in-memory `/tmp`. Logs use Docker's `json-file` driver with three 10 MB files retained.
