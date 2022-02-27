output "vault-auto-unseal-key" {
  value       = module.arctiq-vault.vault-auto-unseal-key
  description = "vault auto unseal key"
}

output "vault-namespace" {
  value       = module.arctiq-vault.vault-namespace
  description = "vault namespace"
}