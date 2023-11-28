module "vote-service"{
    source = "./modules/k8s-services/"
    metadata_name = "vote"
    label_app = "vote"
    type = "NodePort"
    port_name = "vote-service"
    port = 5000
    target_port = 80
    node_port = 31000
}

module "result-service"{
    source = "./modules/k8s-services/"
    metadata_name = "result"
    label_app = "result"
    type = "NodePort"
    port_name = "result-service"
    port = 5001
    target_port = 80
    node_port = 31001
}

resource "kubernetes_service_v1" "redis" {
  metadata {
    name = "redis"
    labels = {
      App = "redis"
    }
  }

  spec {
    type = "ClusterIP"

    port {
      name       = "redis-service"
      port       = 6379
      target_port = 6379
    }

    selector = {
      App = "redis"
    }
  }
}

resource "kubernetes_service_v1" "db" {

  metadata {
    name = "db"
    labels = {
      App = "db"
    }
  }

  spec {
    type = "ClusterIP"

    port {
      name       = "db-service"
      port       = 5432
      target_port = 5432
    }

    selector = {
      App = "db"
    }
  }
}
