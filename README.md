# Arctiq Vault Demo

## Mission
- Build a Kubernetes cluster using Terraform.
- Deploy Vault with auto-unseal capabilities enabled and implement a
cloud Dynamic Secrets Engine which is leveraged by Terraform for
automating deployments of cloud infrastructure
- Bonus: Demonstrate how this could be integrated with a CI/CD
pipeline

## Setup
### Terraform backend

Some backends required user:pass embedded into connection ...
```
terraform {
  backend "pg" {
    conn_str = "postgres://postgres:SECRET_IN_PLAIN_TEXT@tower.home/terraform?sslmode=disable"
  }
}
```

Symlink to it
```
ln -s ~/.ssh/.ssh/terraform_postrgress_backend.tf eks/backend.tf
ln -s ~/.ssh/.ssh/terraform_postrgress_backend.tf vault/backend.tf
```

Ignore symlinks
```
find . -name "backend.tf" -type l | sed -e s'/^\.\///g' >> .gitignore
```

### Quick EKS
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl create cluster \
    --name=arctiq-eks \
    --region=us-east-1 \
    --zones=us-east-1a,us-east-1b,us-east-1c \
    --node-type=t4g.large \
    --nodes=3
```

https://learn.hashicorp.com/tutorials/vault/kubernetes-amazon-eks?in=vault/kubernetes

helm repo add hashicorp https://helm.releases.hashicorp.com

helm install vault hashicorp/vault \
    --namespace='demo' \
    --create-namespace \
    --set='injector.enabled=false' \
    --set='server.ha.enabled=true' \
    --set='server.ha.raft.enabled=true'

kubectl --namespace=demo exec vault-0 -- vault status

kubectl --namespace=demo exec vault-0 -- vault operator init \
    -key-shares=5 \
    -key-threshold=3 \
    -format=json > cluster-keys.json

CLUSTER_ROOT_TOKEN=$(cat cluster-keys.json | jq -r ".root_token")
<cluster-keys.json jq -r '.unseal_keys_b64[]' | while read k;do kubectl --namespace=demo exec vault-0 -- vault operator unseal $k; done

kubectl --namespace=demo exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
kubectl --namespace=demo exec vault-0 -- vault login $CLUSTER_ROOT_TOKEN

kubectl --namespace=demo exec vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
kubectl --namespace=demo exec vault-2 -- vault operator raft join http://vault-0.vault-internal:8200

<cluster-keys.json jq -r '.unseal_keys_b64[]' | while read k;do kubectl --namespace=demo exec vault-1 -- vault operator unseal $k; done
<cluster-keys.json jq -r '.unseal_keys_b64[]' | while read k;do kubectl --namespace=demo exec vault-2 -- vault operator unseal $k; done

kubectl --namespace=demo exec vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
kubectl --namespace=demo exec vault-2 -- vault operator raft join http://vault-0.vault-internal:8200

# Cleanup
terraform destroy

## terraform helm provider does not delete PVCs
kubectl -n vault delete pvc --all