provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "ryt704@arctiq-eks.us-west-1.eksctl.io"
}

resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}
