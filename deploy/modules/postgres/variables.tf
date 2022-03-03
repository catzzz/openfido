

variable "vpc_db_subnets"  { type = list(string)}
variable "vpc_id" {type = string}
variable "common_tags" { type = map(string) }
variable "prefix" {type = string}
variable "environment" {type = string}
variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_engine" {
  type = string
}

variable "db_engine_version" {
   type = string
}

variable "db_name" {
    type = string
}

variable "db_port" {
  type = number
}

variable "db_class" {
   type = string
}

variable "security_group_bastion_id" {
  type = string
}

