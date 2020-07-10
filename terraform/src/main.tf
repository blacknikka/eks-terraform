terraform {
  required_version = ">= 0.12.0"
  #   backend "s3" {
  #     region  = "ap-northeast-1"
  #     encrypt = true

  #     bucket = "terraform-bucket-fortfstate"
  #     key    = "terraform.tfstate"
  #   }
}

provider "aws" {
  region = "ap-northeast-1"
  #   assume_role {
  #     role_arn = var.assume_role
  #   }
}

module "network" {
  source = "./modules/network"

  base_name = var.base_name
}

module "eks" {
  source = "./modules/eks"

  base_name = var.base_name
  subnet1   = module.network.subnet_a
  subnet2   = module.network.subnet_c
  vpc_main  = module.network.vpc_main
}

