provider "aws" {
  region = "us-east-1"
}


// step 1
module "vpc" {
  source      = "./modules/vpc"
  environment = terraform.workspace
  client      = var.client


  common_tags = merge(
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

  common_tags = merge(
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

  common_tags = merge(
    local.common_tags,
    tomap({ Name = "${local.prefix}-db" })
  )
}



// step 4 ecs cluster
module "ecs-cluster" {
  source      = "./modules/ecs-cluster"
  environment = terraform.workspace
  prefix      = var.prefix

  // pre set variable of ecr and ecs
  # ecr_base_url = var.ecr_base_url
  # ecs_name = "auth"
  # ecs_port = 5000
  # image_tag = "master"
  # ecs_health_check_path = "/healthcheck"

  # // Dependencies of VPC output
  # vpc_id = module.vpc.vpc_id
  # vpc_default_sg = module.vpc.vpc_default_sg
  # vpc_public_subnets = module.vpc.vpc_public_subnets
  # vpc_private_subnets = module.vpc.vpc_private_subnets

  # // Dependencies of Database output
  # db_user = module.postgres.db_instance_username
  # db_password = module.postgres.db_instance_password
  # db_endpoint = module.postgres.db_instance_address
  # db_sg_id = module.postgres.db_instance_port

  # //Dependencies of Front-end variable
  # cf_domain =   "https://app-staging.openfido.org"
  # s3_blob_name =  "openfido-dev-blob"
  # s3_blob_arn = "arn:aws:s3:::openfido-stage-blob"

  common_tags = merge(
    local.common_tags,
    tomap({ Name = "${local.prefix}-ecs-cluster" })
  )
}


// step 5. create auth task
module "ecs-auth-task" {
  prefix                                       = var.prefix
  source                                       = "./modules/ecs-auth-task"
  ecr_base_url                                 = var.ecr_base_url
  image_tag                                    = "master"
  ecs_health_check_path                        = "/healthcheck"
  ecs_container_port                           = 5000
  ecs_host_port                                = 5000
  environment                                  = terraform.workspace
  task_name                                    = "auth"
  sendgrid_password_rest_template_id           = var.sendgrid_password_rest_template_id
  sendgrid_api_key                             = var.sendgrid_api_key
  sendgrid_organization_invitation_template_id = var.sendgrid_organization_invitation_template_id

  db_user     = var.db_user
  db_password = var.db_password
  db_endpoint = module.postgres.db_instance_address
  cf_domain   = "https://app-staging.openfido.org" # this variable has to change in production . not finish

  s3_blob_name = "openfido-dev-blob" # this variable has to change in production . not finish


  vpc_id              = module.vpc.vpc_id
  vpc_public_subnets  = module.vpc.vpc_public_subnets
  vpc_private_subnets = module.vpc.vpc_private_subnets

  aws_iam_role_task_execution_role_arn = module.ecs-cluster.aws_iam_role_task_execution_role_arn
  aws_iam_role_app_iam_role_arn        = module.ecs-cluster.aws_iam_role_app_iam_role_arn

  ecs_cluster_name = module.ecs-cluster.ecs_cluster_name

  common_tags = merge(
    local.common_tags,
    tomap({ Name = "${local.prefix}-auth-task" })
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



