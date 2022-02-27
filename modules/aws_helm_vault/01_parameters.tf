variable "aws_region" {
  type     = string
  nullable = false
}

variable "aws_credentials" {
  type     = list(string)
  nullable = false
}

variable "aws_role" {
  type     = string
  nullable = false
}

variable "k8s_config_path" {
  type     = string
  nullable = false
}

variable "k8s_config_context" {
  type     = string
  nullable = false
}

variable "vault_namespace" {
  type     = string
  nullable = false
}
