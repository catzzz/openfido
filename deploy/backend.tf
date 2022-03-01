terraform {
  backend "s3" {
    bucket         = "openfido-stage-tfstate"
    key            = "enviroments/stage/deploy2/openfido-stage.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "openfido-stage-tf-state-lock"
  }
}
