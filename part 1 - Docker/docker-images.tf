resource "docker_image" "vote" {
  name         = "example-voting-app"
  build {
    context = "../example-voting-app/vote/"
  }
}

resource "docker_image" "result" {
  name       = "example-voting-app-result"
  build {
    context = "../example-voting-app/result/"
  }
}

resource "docker_image" "worker" {
  name         = "example-voting-app-worker"
  build {
    context = "../example-voting-app/worker/"
  }
}

resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}

resource "docker_image" "redis" {
  name = "docker.io/redis:6.0.5"
}

resource "docker_image" "seed" {
  name       = "example-voting-app-seed"
  build {
    context = "../example-voting-app/seed-data/"
  }
}