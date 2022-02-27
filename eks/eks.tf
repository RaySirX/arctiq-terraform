provider "eksctl" {}

resource "eksctl_cluster" "arctiq-eks" {
  eksctl_bin = "eksctl"
  version    = "1.21"
  name       = "arctiq-eks"
  region     = "us-west-1"
  spec       = <<-EOS
  nodeGroups:
  - name: ng01
    instanceType: t4g.large
    desiredCapacity: 3
  EOS
}
