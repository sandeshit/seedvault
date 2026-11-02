#!/usr/bin/env bash
# Report on the Seedvault development environment: containers, catalogue size, import blocks.
set -euo pipefail

echo "== Containers =="
for c in seedvault-db seedvault-cache; do
  docker inspect -f "$c
  id:      {{.Id}}
  started: {{.State.StartedAt}}
  status:  {{.State.Status}}" "$c"
done

echo
echo "== Catalogue =="
count=$(docker exec seedvault-db psql -U seedvault -d seedvault -tAc "SELECT count(*) FROM seeds")
echo "seed records: $count"

echo
echo "== Import blocks =="
cat <<BLOCKS
import {
  to = docker_network.app
  id = "seedvault-net"
}

import {
  to = docker_volume.pgdata
  id = "seedvault-pgdata"
}

import {
  to = docker_container.db
  id = "$(docker inspect -f '{{.Id}}' seedvault-db)"
}

import {
  to = docker_container.cache
  id = "$(docker inspect -f '{{.Id}}' seedvault-cache)"
}
BLOCKS
