#!/bin/sh
set -eu

docker compose up --detach --build --wait "$@"
