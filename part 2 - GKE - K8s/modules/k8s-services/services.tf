# module k8s service

variable "metadata_name" {
  type = string
}

variable "label_app" {
  type = string
}

variable "type" {
  type = string
}

variable "port_name" {
  type = string
}

variable "port" {
  type = number
}

variable "target_port" {
  type = number
}

variable "node_port" {
  type = number
}

resource "kubernetes_service_v1" "service" {

  metadata {
    name = var.metadata_name
    labels = {
      App = var.label_app
    }
  }

  spec {
    type = var.type

    port {
      name       = var.port_name
      port       = var.port
      target_port = var.target_port
    }

    selector = {
      App = var.label_app
    }
  }
}


