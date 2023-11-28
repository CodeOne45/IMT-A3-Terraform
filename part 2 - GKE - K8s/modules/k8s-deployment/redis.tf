resource "kubernetes_deployment_v1" "redis" {

  metadata {
    name = "redis"
    labels = {
      app = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        containers {
          name  = "redis"
          image = "redis:alpine"

          ports {
            container_port = 6379
            name           = "redis"
          }

          volume_mounts {
            mount_path = "/data"
            name       = "redis-data"
          }
        }

        volumes {
          name = "redis-data"
          empty_dir {}
        }
      }
    }
  }
}
