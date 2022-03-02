# output "secret_key" {
#   value = random_password.secret.result
# }

output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

# output "auth_domain" {
#   value = "https://${var.auth_subdomain[local.env].subdomain}"
# }
