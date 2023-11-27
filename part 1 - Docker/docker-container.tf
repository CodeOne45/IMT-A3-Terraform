
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



resource "docker_container" "seed" {
  name     = "seed"
  image    = docker_image.seed.image_id

  networks_advanced {
    name = "front-tier"
  }

  depends_on = [docker_container.vote]
}


