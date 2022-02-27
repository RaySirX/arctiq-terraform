resource "aws_kms_key" "vault-auto-unseal-key" {
  description             = "Vault unseal key"
  deletion_window_in_days = 7

  tags = {
    Name = "vault-auto-unseal-key"
  }
}
