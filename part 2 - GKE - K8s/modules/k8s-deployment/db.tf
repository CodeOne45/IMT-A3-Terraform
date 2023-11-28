resource "kubernetes_deployment_v1" "db" {
  metadata {
    name = "db"
    labels = {
      app = "db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "db"
      }
    }

    template {
      metadata {
        labels = {
          App = "db"
        }
      }

      spec {
        containers {
          name  = "postgres"
          image = "postgres:15-alpine"

          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = "postgres"
          }

          ports {
            container_port = 5432
            name           = "postgres"
          }

          volume_mounts {
            mount_path = "/var/lib/postgresql/data"
            name       = "db-data"
          }
        }

        volumes {
          name = "db-data"
          empty_dir {}
        }
      }
    }
  }
}
