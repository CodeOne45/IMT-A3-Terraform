terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}



# Networks
resource "docker_network" "front-tier" {
  name = "front-tier"
}
resource "docker_network" "back-tier" {
  name = "back-tier"
}



#
# Vote
#
resource "docker_image" "image_vote" {
  name = "image_vote"
  build {
    context = "../example-voting-app/vote/"
  }
}
resource "docker_container" "vote" {
  name  = "vote"
  image = docker_image.image_vote.image_id
  ports {
    internal = "80"
    external = "5000"
  }
  
  depends_on = [docker_container.redis_db]

  networks_advanced {
    name = docker_network.front-tier.name
  }
  networks_advanced {
    name = docker_network.back-tier.name
  }
}



#
# Results
#
resource "docker_image" "image_result" {
  name = "image_result"
  build {
    context = "../example-voting-app/result/"
  }
}
resource "docker_container" "result" {
  name  = "result"
  image = docker_image.image_result.image_id

  ports {
    internal = "80"
    external = "5001"
  }
  
  depends_on = [docker_container.postgres_db]

  entrypoint = ["nodemon",  "--inspect=0.0.0.0", "server.js"]

  networks_advanced {
    name = docker_network.front-tier.name
  }
  networks_advanced {
    name = docker_network.back-tier.name
  }
}



#
# Worker
#
resource "docker_image" "image_worker" {
  name = "image_worker"
  build {
    context = "../example-voting-app/worker/"
  }
}
resource "docker_container" "worker" {
  name  = "worker"
  image = docker_image.image_worker.image_id

  depends_on = [
    docker_container.redis_db,
    docker_container.postgres_db
  ]

  networks_advanced {
    name = docker_network.front-tier.name
  }
  networks_advanced {
    name = docker_network.back-tier.name
  }
}



#
#  Redis
#
resource "docker_image" "redis" {
  name = "redis:alpine"
}
resource "docker_container" "redis_db" {
  name  = "redis"
  image = docker_image.redis.image_id

  healthcheck {
    test = ["../example-voting-app/healthchecks/redis.sh"]
    interval = "5s"
  }

  networks_advanced {
    name = docker_network.front-tier.name
  }
  networks_advanced {
    name = docker_network.back-tier.name
  }
}



#
#  Postgres
#
resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}
resource "docker_container" "postgres_db" {
  name  = "db"
  image = docker_image.postgres.image_id

  healthcheck {
    test = ["../example-voting-app/healthchecks/postgres.sh"]
    interval = "5s"
  }

  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=postgres"
  ]

  volumes {
    container_path="../example-voting-app/db-data:/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.back-tier.name
  }
}


# Outputs
output "vote_endpoint" {
  value = "http://localhost:${docker_container.vote.ports[0].external}"
  description = "The URL endpoint to access the vote application"
}

output "result_endpoint" {
  value = "http://localhost:${docker_container.result.ports[0].external}"
  description = "The URL endpoint to access the results application"
}