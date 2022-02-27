resource "helm_release" "vault" {
  name      = "vault"
  namespace = "demo"

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"

  values = [
    "${file("../../modules/aws_helm_vault/values.yaml")}"
  ]

  set {
    name  = "server.extraEnvironmentVars.VAULT_SEAL_TYPE"
    value = "awskms"
  }
  set {
    name  = "server.extraEnvironmentVars.VAULT_AWSKMS_SEAL_KEY_ID"
    value = aws_kms_key.vault-auto-unseal-key.id
  }

  provisioner "local-exec" {
    command = "../../modules/aws_helm_vault/post-tf-apply"
  }

}
