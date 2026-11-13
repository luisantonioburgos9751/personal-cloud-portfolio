terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

#Configured the AWS Providers 
provider "aws" {
  region = "us-east-2"
}