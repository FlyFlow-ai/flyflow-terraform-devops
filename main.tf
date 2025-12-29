terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.32"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
  backend "s3" {
    bucket         = "flyflow-tfstate"
    key            = "infra2.0/subaccounts/feature/flyflow-terraform-main/flyflow-terraform-main.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-locking"
    profile        = "sandbox_hydra"
  }
}
provider "docker" {}

locals {
  environment = "staging"
}


module "devops" {
  source       = "terraform"
  key_ssm_name = "/key_pairs/aws_flyflow/public_key"
  ssh_key_name = "aws_flyflow_generated"
  env          = "staging"
}
