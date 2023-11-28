resource "kubernetes_deployment_v1" "result" {

  metadata {
    name = "result"
    labels = {
      app = "result"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "result"
      }
    }

    template {
      metadata {
        labels = {
          app = "result"
        }
      }

      spec {
        containers {
          name  = "result"
          image = "dockersamples/examplevotingapp_result"

          ports {
            container_port = 80
            name           = "result"
          }
        }
      }
    }
  }
}
