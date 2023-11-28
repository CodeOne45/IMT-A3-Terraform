resource "kubernetes_service_v1" "redis" {
  metadata {
    name = "redis"
    labels = {
      app = "redis"
    }
  }

  spec {
    type = "ClusterIP"

    ports {
      name       = "redis-service"
      port       = 6379
      target_port = 6379
    }

    selector = {
      app = "redis"
    }
  }
}