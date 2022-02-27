# Arctiq Vault Demo

## Mission
[X] Build a Kubernetes cluster using Terraform.

[X] Deploy Vault 

[X] with auto-unseal capabilities enabled 

[_]and implement a cloud Dynamic Secrets Engine which is leveraged by Terraform for
automating deployments of cloud infrastructure

[_] Bonus: Demonstrate how this could be integrated with a CI/CD pipeline

## Setup
### Directory structure
deploy - root level terraform
modules - modular eks and vault
extras - keep the dir clean of stuff

### Extenal access requirements
deploy/*/00-workspaces.tf
- aws_credential - point to AWS credentials file
- k8s_config_path - eksctl will modify kube config for PC access

deploy/*/01_backend_s3.tf - state file

## Run it
cd deploy/eks
terraform init
terraform workspace new eks-demo
terraform plan -out eks.plan
terraform apply eks.plan

cd deploy/vault
terraform init
terraform workspace new vault-demo
terraform plan -out vault.plan
terraform apply vault.plan

## Terraform post vault setup - modules/aws_helm_vault/post-tf-apply
post-tf-apply script "should" run post EKS deploy
- initialize vault
-- kubes:/demo/hashivault secret - stores the root_token and recovery keys
-- kubes:/demo/kms-creds secret - auto-unseal - aws creds vault will use to fetch master key from KMS
- dynamically add vaults to cluster
- sanity check
-- login to vault-0 using stored root token
-- display raft cluster state

## Quick AWS EKS
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

## Quick Vault
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
