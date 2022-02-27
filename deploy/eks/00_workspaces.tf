variable "workspaces" {
  type = map(any)

  default = {
    // workspace demo
    eks-demo = {
      "aws_region"         = "us-west-1",
      "aws_credentials"    = ["/home/rtai/.aws/credentials"],
      "workspace_iam_role" = "arn:aws:iam::871701630441:role/terraform-dev"

      "instance_type" = "t4g.medium",

      "k8s_config_path"    = "~/.kube/config"
      "k8s_config_context" = "ryt704@arctiq-eks.us-west-1.eksctl.io",

      "eks_namespaces" = { "demo" = { name = "demo " } }
    }
  }
}
