variable "metadata_name" {
  type = string
}

variable "metadata_namespace" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_port" {
  type = number
}

resource "kubernetes_ingress_v1" "result-ingess" {
  metadata {
    name      = var.metadata_name
    namespace = var.metadata_namespace
  }

  spec {
    default_backend {
      service {
        name = var.service_name
        port {
          number = var.service_port
        }
      }
    }
  }
}
