//--------------------------------------------------------------------
// Resources

resource "aws_kms_key" "kms-creds" {
  description             = "Vault unseal key"
  deletion_window_in_days = 7

  tags = {
    Name = "vault-kms-unseal-key"
  }
}
