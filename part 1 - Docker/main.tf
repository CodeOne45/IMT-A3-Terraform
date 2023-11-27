terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

resource "docker_image" "vote" {
  name         = "example-voting-app-vote"
  build {
    context = "../example-voting-app-vote/vote"
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
    container_path = "../example-voting-app-vote/vote:/usr/local/app"
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
    context = "../example-voting-app-vote/result"
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
    container_path = "../example-voting-app-vote/result:/usr/local/app"
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
    context = "../example-voting-app-vote/worker"
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


resource "docker_container" "redis" {
  name  = "redis"
  image = "redis:alpine"

  volumes {
    container_path = "../example-voting-app-vote/healthchecks:/healthchecks"
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

resource "docker_container" "db" {
  name  = "db"
  image = "postgres:15-alpine"

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

resource "docker_container" "seed" {
  name     = "seed"
  image    = "example-voting-app-seed:latest"

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
