terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  backend "s3" {} // bucket should be exist before initializing terraform.

  required_version = ">= 1.2"
}

provider "aws" {
  region  = var.region
}



module "vpc" {
  source            = "./modules/vpc"
  availability_zone = var.availability_zone
}

module "ssh_keypair" {
  source = "./modules/ssh_keypair"
}

module "ec2_module" {
  source = "./modules/ec2"

  instance_type = var.instance_type
  subnet_id     = module.vpc.main_subnet_id
  sg_id         = module.vpc.sg_id
  ami_id        = var.ami_id
  key_pair_name = module.ssh_keypair.key_pair_name

  depends_on = [module.ssh_keypair, module.vpc]
}


