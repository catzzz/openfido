provider "aws" {
  region = "us-east-1"
}



module "vpc" {
  source      = "./modules/vpc"
  environment = terraform.workspace
  client      = var.client

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



