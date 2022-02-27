module "arctiq-eks" {
  source = "../../modules/aws_eksctl"

  aws_region      = var.workspaces[terraform.workspace]["aws_region"]

  k8s_instance_type  = var.workspaces[terraform.workspace]["instance_type"]
}
