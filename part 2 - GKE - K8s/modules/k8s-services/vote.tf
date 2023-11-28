resource "kubernetes_service_v1" "vote" {
  metadata {
    name = "vote"
    labels = {
      app = "vote"
    }
  }

  spec {
    type = "NodePort"

    ports {
      name       = "vote-service"
      port       = 5000
      target_port = 80
      node_port  = 31000
    }

    selector = {
      app = "vote"
    }
  }
}
