
output "db_endpoint" {
  description = "The database endpoint for connection"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.main.address
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = var.db_user
}

output "db_instance_password" {
  description = "The database password for connection"
  value       = aws_db_instance.main.password
  sensitive   = true
}

output "db_instance_name" {
  description = "The master password for the database"
  value       = aws_db_instance.main.db_name
}

output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.main.port
}

output "db_sg_id" {
  description = "The database security group id"
  value       = aws_security_group.rds.id
}
