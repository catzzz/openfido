# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    key            = "enviroments/prod/services/ecs_worker/terraform.tfstate"
    profile        = "openfido-prod"
    region         = "us-east-1"
    bucket         = "openfido-prod-remote-state"
    dynamodb_table = "openfido-prod-remote-state-lock"
    encrypt        = true
  }
}