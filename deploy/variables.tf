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