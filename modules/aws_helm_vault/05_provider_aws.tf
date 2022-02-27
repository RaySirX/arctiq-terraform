provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = var.aws_credentials

  assume_role {
    role_arn = var.aws_role
  }
}
