terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

resource "docker_image" "vote" {
  name         = "example-voting-app"
  build {
    context = "../example-voting-app/vote/"
  }
}

resource "docker_container" "vote" {
  name  = "vote"
  image = docker_image.vote.image_id


  ports {
    internal = 80
    external = 5002
  }

  volumes {
    container_path = "../example-voting-app/vote:/usr/local/app"
  }

  networks_advanced {
    name = "front-tier"
  }

  networks_advanced {
    name = "back-tier"
  }

  depends_on = [docker_container.redis]
}

resource "docker_image" "result" {
  name       = "example-voting-app-result"
  build {
    context = "../example-voting-app/result/"
  }
}

resource "docker_container" "result" {
  name  = "result"
  image = docker_image.result.image_id

  ports {
    internal = 80
    external = 5003
  }

  volumes {
    container_path = "../example-voting-app/result:/usr/local/app"
  }

  networks_advanced {
    name = "front-tier"
  }

  networks_advanced {
    name = "back-tier"
  }

  depends_on = [docker_container.db]
}

resource "docker_image" "worker" {
  name         = "example-voting-app-worker"
  build {
    context = "../example-voting-app/worker/"
  }
}

resource "docker_container" "worker" {
  name  = "worker"
  image = docker_image.worker.image_id

  networks_advanced {
    name = "back-tier"
  }

  depends_on = [docker_container.redis, docker_container.db]
}

resource "docker_image" "redis" {
  name = "docker.io/redis:6.0.5"

}
resource "docker_container" "redis" {
  name  = "redis"
  image = docker_image.redis.name

  volumes {
    container_path = "../example-voting-app/healthchecks:/healthchecks"
  }

  healthcheck {
    test        = ["/bin/sh", "-c", "test -f /healthchecks/redis.sh"]
    interval    = "5s"
    start_period = "10s"
  }

  networks_advanced {
    name = "back-tier"
  }
}

resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}
resource "docker_container" "db" {
  name  = "db"
  image = docker_image.postgres.name

  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=postgres"
  ]

  volumes {
    container_path = "db-data:/var/lib/postgresql/data"
  }

  healthcheck {
    test        = ["/bin/sh", "-c", "test -f /healthchecks/postgres.sh"]
    interval    = "5s"
    start_period = "10s"
  }

  networks_advanced {
    name = "back-tier"
  }
}

resource "docker_image" "seed" {
  name       = "example-voting-app-seed"
  build {
    context = "../example-voting-app/seed/"
  }
}

resource "docker_container" "seed" {
  name     = "seed"
  image    = docker_image.seed.image_id

  networks_advanced {
    name = "front-tier"
  }

  depends_on = [docker_container.vote]
}

resource "docker_network" "front_tier" {
  name = "front-tier"
}

resource "docker_network" "back_tier" {
  name = "back-tier"
}

resource "docker_volume" "db_data" {
  name = "db-data"
}
