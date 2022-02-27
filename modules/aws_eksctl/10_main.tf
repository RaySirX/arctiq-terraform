resource "eksctl_cluster" "k8s" {
  eksctl_bin = "eksctl"
  version    = "1.21"
  name       = "arctiq-eks"
  region     = var.aws_region
  spec       = <<-EOS
  nodeGroups:
  - name: ng01
    instanceType: ${var.k8s_instance_type}
    desiredCapacity: ${var.k8s_num_nodes}
  EOS
}
