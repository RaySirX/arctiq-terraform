variable "workspaces" {
  type = map(any)

  default = {
    // workspace prod
    prod = {
      aws_region          = "us-east-1",
      credentials_file    = "/home/rtai/.aws/credentials",
      instance_type       = "t2.micro",
      vpc_cidr            = "172.31.0.0/16",
      vpc_private_azs     = ["us-east-1a", "us-east-1b", "us-east-1c"],
      vpc_private_subnets = ["172.31.16.0/20", "172.31.32.0/20", "172.32.48.0/20"],
      vpc_public_azs      = ["us-east-1a", "us-east-1b", "us-east-1c"],
      vpc_public_subnets  = ["172.31.64.0/20", "172.31.80.0/20"],
      workspace_iam_role  = "arn:aws:iam::871701630441:role/terraform-prod",
    }

    // workspace demo
    eks-demo = {
      aws_region          = "us-west-1",
      credentials_file    = "/home/rtai/.aws/credentials",
      instance_type       = "t4g.medium",
      vpc_cidr            = "172.30.0.0/16",
      vpc_private_azs     = ["us-east-1a", "us-east-1b", "us-east-1c"],
      vpc_private_subnets = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"],
      vpc_public_azs      = ["us-east-1d", "us-east-1e"],
      vpc_public_subnets  = ["192.168.101.0/24", "192.168.102.0/24", "192.168.103.0/24"],
      workspace_iam_role  = "arn:aws:iam::871701630441:role/terraform-dev"
    }
  }
}
