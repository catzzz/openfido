variable "aws_tags" { type = map(string) }
variable "prefix" {type = string}
variable "bastion_key_name" {type = string}
variable "vpc_private_subnets"  { }
variable "vpc_public_subnets"  { type = list(string) }
variable "vpc_id" {type = string}

data "aws_availability_zones" "available" {}


