provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "vault" {
  name      = "vault"
  namespace = "demo"

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"

  values = [
    "${file("values.yaml")}"
  ]

  set {
    name  = "server.extraEnvironmentVars.VAULT_SEAL_TYPE"
    value = "awskms"
  }
  set {
    name  = "server.extraEnvironmentVars.VAULT_AWSKMS_SEAL_KEY_ID"
    value = aws_kms_key.kms-creds.id
  }
}
