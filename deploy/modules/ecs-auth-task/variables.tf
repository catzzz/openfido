# // MakeFile variable
variable "environment" { type = string }

variable "prefix" {type =string}
# // Common variables


variable "common_tags" { type = map(string) }

# // ECS Variables
variable "ecr_base_url" {
    description = "The ecr base url."
    type = string
}

variable "task_name" {
    description = "The task name"   
    type = string
}


variable "ecs_container_port" {
  description = "The containers port."
  type        = number
}
variable "ecs_host_port" {
  description = "The containers port."
  type        = number
}
variable "image_tag" {
  description = "The containers image tag."
  type        = string
}
variable "ecs_health_check_path" {
  description = "The containers health check path."
  type        = string
}

# // Inherit from vpn module
variable "vpc_id" { type = string }
# variable "vpc_default_sg" { type = string }
variable "vpc_public_subnets" { type = list(string) }
variable "vpc_private_subnets" { type = list(string) }
variable "db_user" { type = string }
variable "db_password" { type = string }
variable "db_endpoint" { type = string }
# variable "db_sg_id" { type = string }
variable "cf_domain" { type = string }
variable "s3_blob_name" { type = string }
# variable "s3_blob_arn" { type = string }

# // Domain Certificate ARN
# variable "auth_subdomain" {
#   type = map(object({
#     zone_id   = string
#     subdomain = string
#     acm_arn   = string
#   }))
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


data "aws_region" "current" {}

variable "aws_iam_role_task_execution_role_arn" {
    type = string
}

variable "aws_iam_role_app_iam_role_arn" {
    type = string
}

variable "ecs_cluster_name" {
    type = string
}