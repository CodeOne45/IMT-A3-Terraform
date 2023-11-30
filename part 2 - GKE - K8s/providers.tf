variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}




variable "GOOGLE_CREDENTIALS_File" {
  type = any
}

# example of GOOGLE_CREDENTIALS


provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  credentials = var.GOOGLE_CREDENTIALS_File
}

data "google_client_config" "default" {}


provider "kubernetes" {
  host  = "https://${google_container_cluster.mycluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.mycluster.master_auth[0].cluster_ca_certificate,
  )
}

