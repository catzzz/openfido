// MakeFile variable
variable "environment" { type = string }

// Common variables

variable "client" { type = string }
variable "common_tags" { type = map(string) }



data "aws_availability_zones" "available" {}
