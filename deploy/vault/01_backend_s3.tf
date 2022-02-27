terraform {
  backend "s3" {
    bucket = "raysirx-terraform"
    key    = "arctiq/demo/terraform.tfstate"
    region = "us-east-1"
  }
}
