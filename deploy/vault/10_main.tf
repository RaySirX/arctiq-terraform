module "arctiq-vault" {
#  source = "../../modules/vault"
  source = "../../modules/aws_helm_vault"

  aws_region      = var.workspaces[terraform.workspace]["aws_region"]
  aws_credentials = var.workspaces[terraform.workspace]["aws_credentials"]
  aws_role        = var.workspaces[terraform.workspace]["workspace_iam_role"]

  k8s_config_path    = var.workspaces[terraform.workspace]["k8s_config_path"]
  k8s_config_context = var.workspaces[terraform.workspace]["k8s_config_context"]

  vault_namespace = var.workspaces[terraform.workspace]["vault_namespace"]
}
