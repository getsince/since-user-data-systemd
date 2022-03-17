data "aws_vpc" "since" {
  cidr_block = "10.0.0.0/16"
}

data "aws_vpc" "since_ohio" {
  cidr_block = "10.1.0.0/16"
  provider   = aws.ohio
}

data "aws_subnets" "since" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.since.id]
  }
}

data "aws_subnets" "since_ohio" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.since_ohio.id]
  }

  provider = aws.ohio
}

# 10.0.0.0/16 <-> 10.0.0.0/16
data "aws_security_group" "since" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.since.id]
  }

  name = "default"
}

# 10.1.0.0/16 <-> 10.1.0.0/16
data "aws_security_group" "since_ohio" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.since_ohio.id]
  }

  name = "default"

  provider = aws.ohio
}

resource "aws_security_group" "ruslan_ssh" {
  name   = "ruslan_ssh2"
  vpc_id = data.aws_vpc.since.id

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
}
