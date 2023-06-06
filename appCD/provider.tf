terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "cafi-demo1"
    key    = "E-Commerce-Microservice-Platform/infrastructure/terraform.tfstate"
    region = "us-east-1"
    role_arn = "arn:aws:iam::180217099948:role/atlantis-access"
  }
}

provider "aws" {
  region  = var.region
  assume_role {
    role_arn = "arn:aws:iam::180217099948:role/atlantis-access"
  }
}

