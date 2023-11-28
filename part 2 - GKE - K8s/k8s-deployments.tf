module "resultat-kubernetes_deployment" {
    source = "./modules/deployment/"
    metadata_name = "result"
    label_app = "result"
    container_name = "result"
    container_image = "dockersamples/examplevotingapp_result"
    container_port = 80
}

module "vote-kubernetes_deployment" {
    source = "./modules/deployment/"
    metadata_name = "vote"
    label_app = "vote"
    container_name = "vote"
    container_image = "dockersamples/examplevotingapp_vote"
    container_port = 80
}


resource "kubernetes_deployment_v1" "db" {
  metadata {
    name = "db"
    labels = {
      App = "db"
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
        container {
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

          port {
            container_port = 5432
            name           = "postgres"
          }

          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "db-data"
          }
        }

        volume {
          name = "db-data"
          empty_dir {}
        }
      }
    }
  }
}


resource "kubernetes_deployment_v1" "redis" {

  metadata {
    name = "redis"
    labels = {
      App = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "redis"
      }
    }

    template {
      metadata {
        labels = {
          App = "redis"
        }
      }

      spec {
        container {
          name  = "redis"
          image = "redis:alpine"

          port {
            container_port = 6379
            name           = "redis"
          }

          volume_mount {
            mount_path = "/data"
            name       = "redis-data"
          }
        }

        volume {
          name = "redis-data"
          empty_dir {}
        }
      }
    }
  }
}


resource "kubernetes_deployment_v1" "worker" {
  metadata {
    name = "worker"
    labels = {
      App = "worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "worker"
      }
    }

    template {
      metadata {
        labels = {
          App = "worker"
        }
      }

      spec {
        container {
          name  = "worker"
          image = "dockersamples/examplevotingapp_worker"
        }
      }
    }
  }
}
