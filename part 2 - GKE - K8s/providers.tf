variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}


terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.6.0"
    }
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = ">= 2.23.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  credentials = var.GOOGLE_CREDENTIALS
}

data "google_client_config" "default" {}


provider "kubernetes" {
  host  = "https://${google_container_cluster.mycluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.mycluster.master_auth[0].cluster_ca_certificate,
  )
}


/*provider "docker" {
  registry_auth {
    address  = "europe-west9-docker.pkg.dev"
    username = "oauth2accesstoken"
    password = data.google_service_account_access_token.sa.access_token
  }
}

data "google_service_account_access_token" "sa" {
  target_service_account = "202152396484-compute@developer.gserviceaccount.com"
  scopes                 = [ "cloud-platform" ]
}*/