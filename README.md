# Seedvault development environment

The seed-library catalogue service uses a PostgreSQL database (the seed catalogue) and a Redis
key-value store (lookup cache). On the development machine they were started by hand with:

```sh
docker network create seedvault-net
docker volume create seedvault-pgdata
docker run -d --name seedvault-db --network seedvault-net --restart unless-stopped \
  -v seedvault-pgdata:/var/lib/postgresql/data \
  -e POSTGRES_DB=seedvault -e POSTGRES_USER=seedvault -e POSTGRES_PASSWORD=dev-only-password \
  postgres:17
docker run -d --name seedvault-cache --network seedvault-net --restart unless-stopped redis:7
```

The catalogue was then loaded from `data/catalogue.sql`.

The Terraform files in this folder (`versions.tf`, `main.tf`) describe the same environment so it
can be managed as code from now on.

`tools/env-report.sh` prints the running containers, the number of catalogue records, and an
import block for each existing resource.
