resource "kubernetes_ingress_v1" "vote-ingess" {
  metadata {
    name = "vote-ingress"
    namespace = "default"
  }
  spec {
    default_backend {
      service {
        name = "vote"
        port {
          number = 5000
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "result-ingess" {
  metadata {
    name = "result-ingress"
    namespace = "default"
  }
  spec {
    default_backend {
      service {
        name = "result"
        port {
          number = 5001
        }
      }
    }
  }
}