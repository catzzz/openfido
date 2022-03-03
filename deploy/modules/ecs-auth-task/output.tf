output "secret_key" {
  value = random_password.secret.result
}



# output "auth_domain" {
#   value = "https://${var.auth_subdomain[local.env].subdomain}"
# }
