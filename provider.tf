terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = var.var_provider.region
  access_key = var.var_provider.access_key
  secret_key = var.var_provider.secret_key
}
