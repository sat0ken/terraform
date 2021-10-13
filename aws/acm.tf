resource "tls_private_key" "example" {
  algorithm = "RSA"
}

# create self-signed certificates
resource "tls_self_signed_cert" "example" {
  key_algorithm   = tls_private_key.example.algorithm
  private_key_pem = tls_private_key.example.private_key_pem

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = [local.domain_name]

  subject {
    common_name = local.domain_name
  }
}

# import self-signed certificates to aws acm
resource "aws_acm_certificate" "cert" {
  certificate_body = tls_self_signed_cert.example.cert_pem
  private_key      = tls_private_key.example.private_key_pem
}

