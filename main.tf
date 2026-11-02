# Seedvault development environment: catalogue database and key-value store.
# Written to match the containers described in README.md.

resource "docker_network" "app" {
  name = "seedvault-net"
}

resource "docker_volume" "pgdata" {
  name = "seedvault-pgdata"
}

resource "docker_container" "db" {
  name    = "seedvault-db"
  image   = "postgres:17"
  restart = "unless-stopped"
  env = [
    "POSTGRES_DB=seedvault",
    "POSTGRES_USER=seedvault",
    "POSTGRES_PASSWORD=dev-only-password",
  ]

  networks_advanced {
    name = docker_network.app.name
  }

  volumes {
    volume_name    = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }
}

resource "docker_container" "cache" {
  name    = "seedvault-cache"
  image   = "redis:7"
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.app.name
  }
}
