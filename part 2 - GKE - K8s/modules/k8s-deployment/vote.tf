resource "kubernetes_deployment_v1" "vote" {
  provider = kubernetes.gke

  metadata {
    name = "vote"
    labels = {
      app = "vote"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "vote"
      }
    }

    template {
      metadata {
        labels = {
          app = "vote"
        }
      }

      spec {
        containers {
          name  = "vote"
          image = "dockersamples/examplevotingapp_vote"

          ports {
            container_port = 80
            name           = "vote"
          }
        }
      }
    }
  }
}
