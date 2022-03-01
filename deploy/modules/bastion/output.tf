output "bastion_host" {
  description = "bastion host address"
  value = aws_instance.bastion.public_dns
}
