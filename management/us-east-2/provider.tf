provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  required_version = ">= 0.14.6"
  required_providers {
    aws = {
      version = ">= 3.32.0"
      source  = "hashicorp/aws"
    }
  }
}
