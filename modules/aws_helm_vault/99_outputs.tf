output "vault-auto-unseal-key" {
  value       = aws_kms_key.vault-auto-unseal-key
  description = "vault auto unseal key"
}

output "vault-namespace" {
  value       = kubernetes_namespace.vault
  description = "vault namespace"
}