module "vpc_stockholm" {
  source = "./vpc"

  cidr = "10.0.0.0/16"

  providers = {
    aws = aws.stockholm
  }
}

module "vpc_ohio" {
  source = "./vpc"

  cidr = "10.1.0.0/16"

  providers = {
    aws = aws.ohio
  }
}

module "vpc_north_california" {
  source = "./vpc"

  cidr = "10.2.0.0/16"

  providers = {
    aws = aws.north_california
  }
}

module "vpc_sydney" {
  source = "./vpc"

  cidr = "10.3.0.0/16"

  providers = {
    aws = aws.sydney
  }
}

module "vpc_sao_paulo" {
  source = "./vpc"

  cidr = "10.4.0.0/16"

  providers = {
    aws = aws.sao_paulo
  }
}

# TODO remove
resource "aws_security_group" "ruslan_ssh" {
  name   = "ruslan_ssh2"
  vpc_id = module.vpc_stockholm.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["13.51.23.171/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  provider = aws.stockholm
}
