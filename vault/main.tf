provider "aws" {
  region                   = var.workspaces[terraform.workspace]["aws_region"]
  shared_credentials_files = ["/home/rtai/.aws/credentials"]

  assume_role {
    role_arn = var.workspaces[terraform.workspace]["workspace_iam_role"]
  }
}
