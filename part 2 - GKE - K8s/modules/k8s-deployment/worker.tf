resource "kubernetes_deployment_v1" "worker" {
  provider = kubernetes.gke

  metadata {
    name = "worker"
    labels = {
      app = "worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "worker"
      }
    }

    template {
      metadata {
        labels = {
          app = "worker"
        }
      }

      spec {
        containers {
          name  = "worker"
          image = "dockersamples/examplevotingapp_worker"
        }
      }
    }
  }
}
