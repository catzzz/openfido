variable "prefix" {
  default = "openfido"
}

variable "project" {
  default = "openfido"
}

variable "contact" {
  default = "jimmyleu@slac.stanford.edu"
}

variable "client" {
  default = "openfido"
}

variable "bastion_key_name" {
  description = "key pair used to login to the ec2 bastion, pre-generated in local computer and import to AWS "
  default     = "openfido-dev-bastion"
}

# database

variable "db_user" {
  description = "Username for the RDS Postgres instance"
  default     = "openfido"
}

variable "db_password" {
  description = "Password for the RDS postgres instance"
}

variable "db_engine" {
  description = "database engine "
  default     = "postgres"
}

variable "db_engine_version" {
  description = "database version "
  default     = "11.8"
}

variable "db_name" {
  description = "database name"
  default     = "appservice"
}

variable "db_port" {
  description = "database port"
  default     = 5432
}

variable "db_class" {
  description = "database class"
  default     = "db.t3.small"
}


data "aws_availability_zones" "available" {}




// Domain Certificate ARN
# variable "front_subdomain" {
#   type = map(object({
#     zone_id   = string
#     subdomain = string
#     acm_arn   = string
#   }))
# }

// ECS 
variable "ecr_base_url" {
  description = "ecr base url"
  default     = "390427513171.dkr.ecr.us-east-1.amazonaws.com/"
}

# variable "ecs_port" {
#   description = "ecr port"
# }
variable "image_tag" {
  description = "image tag "
  default     = "master"
}
# variable "ecs_health_check_path" {
#   description = "health check path"

# }

# variable "cf_domain" {
#   default = "https://${var.front_subdomain[local.env].subdomain}"
# } 
variable "sendgrid_api_key" {
  type = string
}
variable "sendgrid_password_rest_template_id" {
  type = string
}

variable "sendgrid_organization_invitation_template_id" {
  type = string
}

variable "s3_blob_name" {
  type = string
}