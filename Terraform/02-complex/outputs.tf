output "public_key" {
  value = "${tls_private_key.demo.public_key_pem}"
}

output "private_key" {
  value     = "${tls_private_key.demo.private_key_pem}"
  sensitive = true
}

output "instrumentation_key" {
  value = "${azurerm_application_insights.demo.instrumentation_key}"
}

output "password" {
  value     = "${random_string.password.result}"
  sensitive = true
}
