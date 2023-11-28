module "ingress-vote"{
  source = "./modules/ingress/"
  metadata_name = "vote-ingress"
  metadata_namespace = "default"
  service_name = "vote"
  service_port = 5000
}

module "ingress-result"{
  source = "./modules/ingress/"
  metadata_name = "result-ingress"
  metadata_namespace = "default"
  service_name = "result"
  service_port = 5001
}
