# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    profile        = "openfido"
    region         = "us-east-1"
    bucket         = "openfido-remote-state"
    dynamodb_table = "openfido-remote-state-lock"
    encrypt        = true
    key            = "enviroments/dev/vpc/terraform.tfstate"
  }
}
