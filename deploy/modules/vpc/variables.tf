// MakeFile variable
variable "environment" { type = string }

// Common variables

variable "client" { type = string }
variable "aws_tags" { type = map(string) }


// Get AWS Availability zones
data "aws_availability_zones" "available" {}