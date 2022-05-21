terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

}

provider "aws" {
  region = "us-west-1"
  }



##### VPCModule
module "vpc" {
  source = "./modules/VPC_Mod"

  ipblock = "10.0.0.0/16"
}
