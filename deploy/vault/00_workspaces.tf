variable "workspaces" {
  type = map(any)

  default = {
    // workspace demo
    vault-demo = {
      "aws_region"         = "us-west-1",
      "aws_credentials"    = ["/home/rtai/.aws/credentials"],
      "workspace_iam_role" = "arn:aws:iam::871701630441:role/terraform-dev"

      "k8s_config_path"    = "~/.kube/config"
      "k8s_config_context" = "ryt704@arctiq-eks.us-west-1.eksctl.io",

      "vault_namespace"       = "demo"
      "vault_auto_unseal_key" = "36856fd5-78a2-4010-9fef-2b9215a6bd83",
    }
  }
}
