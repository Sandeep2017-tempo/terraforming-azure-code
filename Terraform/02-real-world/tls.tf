resource "tls_private_key" "demo" {
  algorithm = "RSA"
  rsa_bits  = "512"
}
