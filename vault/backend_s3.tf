terraform {
  backend "s3" {
    bucket = "raysirx-terraform"
    key    = "arctiq/master/demo/terraform.tfstate"
    region = "us-east-1"
  }
}
