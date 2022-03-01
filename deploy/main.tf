provider "aws" {
  region = "us-east-1"
}


// step 1
module "vpc" {
  source      = "./modules/vpc"
  environment = terraform.workspace
  client      = var.client

  aws_tags = merge(
    local.common_tags,
    tomap({ Name = "${local.prefix}-vpc" })
  )
}

// step 2
# create a db tunnel by ec2 bastion use ssh 
module "bastion" {
  source = "./modules/bastion"

  prefix              = var.prefix
  bastion_key_name    = var.bastion_key_name
  vpc_public_subnets  = module.vpc.vpc_public_subnets
  vpc_private_subnets = module.vpc.vpc_private_subnets
  vpc_id              = module.vpc.vpc_id

  aws_tags = merge(
    local.common_tags,
    tomap({ Name = "${local.prefix}-bastion" })
  )
}
// step 3
# create db
module "postgres" {
  environment               = terraform.workspace
  source                    = "./modules/postgres"
  vpc_db_subnets            = module.vpc.vpc_db_subnets
  vpc_id                    = module.vpc.vpc_id
  security_group_bastion_id = module.bastion.security_group_bastion_id

  prefix            = var.prefix
  db_user           = var.db_user
  db_password       = var.db_password
  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
  db_name           = var.db_name
  db_port           = var.db_port
  db_class          = var.db_class

  aws_tags = merge(
    local.common_tags,
    tomap({ Name = "${local.prefix}-db" })
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



