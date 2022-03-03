variable "common_tags" { type = map(string) }
variable "prefix" {type = string}
variable "bastion_key_name" {type = string}
variable "vpc_private_subnets"  { type = list(string)}
variable "vpc_public_subnets"  { type = list(string) }
variable "vpc_id" {type = string}

# variable "aws_region_current_name" {type = string}

