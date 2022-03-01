output "bastion_host" {
  description = "bastion host address"
  value = aws_instance.bastion.public_dns
}

output "security_group_bastion_id" {
  description = " security group bastion id"
  value = aws_security_group.bastion.id
}