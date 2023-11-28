resource "kubernetes_service_v1" "result" {

  metadata {
    name = "result"
    labels = {
      app = "result"
    }
  }

  spec {
    type = "NodePort"

    ports {
      name       = "result-service"
      port       = 5001
      target_port = 80
      node_port  = 31001
    }

    selector = {
      app = "result"
    }
  }
}
