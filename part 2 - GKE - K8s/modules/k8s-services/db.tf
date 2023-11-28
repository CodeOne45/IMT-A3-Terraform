resource "kubernetes_service_v1" "db" {

  metadata {
    name = "db"
    labels = {
      app = "db"
    }
  }

  spec {
    type = "ClusterIP"

    ports {
      name       = "db-service"
      port       = 5432
      target_port = 5432
    }

    selector = {
      app = "db"
    }
  }
}
