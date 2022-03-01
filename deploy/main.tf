provider "aws" {
  region = "us-east-1"
}



module "vpc" {
  source      = "./modules/vpc"
  environment = terraform.workspace
  client      = var.client

  aws_tags = merge(
    local.common_tags,
    tomap({ Name = "${local.prefix}-vpc" })
  )
}


# create a db tunnel by ec2 bastion use ssh 
module "bastion" {
  source = "./modules/bastion"

  prefix           = var.prefix
  bastion_key_name = var.bastion_key_name
  vpc_public_subnets  = module.vpc.vpc_public_subnets
  vpc_private_subnets = module.vpc.vpc_private_subnets
  vpc_id              = module.vpc.vpc_id

  aws_tags = merge(
    local.common_tags,
    tomap({ Name = "${local.prefix}-bastion" })
  )
}



locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}



