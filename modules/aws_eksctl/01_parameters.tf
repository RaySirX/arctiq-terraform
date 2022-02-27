variable "aws_region" {
  type     = string
  nullable = false
}

variable "k8s_instance_type" {
  type     = string
  nullable = false
}

variable "k8s_num_nodes" {
  type    = number
  default = 3
}
