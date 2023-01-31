terraform {
  backend "remote" {
    organization = "since"
    workspaces {
      name = "bezos1"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }

  required_version = "~> 1.1"
}

provider "aws" {
  region = "eu-north-1"
}

provider "aws" {
  alias  = "stockholm"
  region = "eu-north-1"
}

provider "aws" {
  alias  = "north_california"
  region = "us-west-1"
}
