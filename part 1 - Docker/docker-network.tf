resource "docker_network" "front_tier" {
  name = "front-tier"
}

resource "docker_network" "back_tier" {
  name = "back-tier"
}

resource "docker_volume" "db_data" {
  name = "db-data"
}