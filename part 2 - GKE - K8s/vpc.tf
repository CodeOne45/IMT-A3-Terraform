resource "google_compute_network" "myvpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "mysubnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.myvpc.name
  ip_cidr_range = "10.10.0.0/24"
}


resource "google_compute_subnetwork" "mysubnets" {
  network       = google_compute_network.myvpc.name

  for_each      = {
    east = {
      region        = "europe-north1"
      ip_cidr_range = "10.8.0.0/24"
    }
    west = {
      region        = "europe-west1"
      ip_cidr_range = "10.9.0.0/24"
    }
  }

  name          = "${var.project_id}-subnet-${each.key}"
  region        = each.value.region
  ip_cidr_range = each.value.ip_cidr_range
}