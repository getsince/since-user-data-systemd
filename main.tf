terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "eu-north-1"
}

provider "aws" {
  alias  = "stockholm"
  region = "eu-north-1"
}

provider "aws" {
  alias  = "ohio"
  region = "us-east-2"
}
