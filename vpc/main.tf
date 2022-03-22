terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }

  required_version = "~> 1.1"
}

data "aws_vpc" "this" {
  cidr_block = var.cidr
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  name = "default"
}

data "aws_security_groups" "peering" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "tag:Name"
    values = ["peering-*"]
  }
}
