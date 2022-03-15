data "aws_vpc" "since" {
  cidr_block = "10.0.0.0/16"
}

data "aws_subnets" "since" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.since.id]
  }
}

# 10.0.0.0/16 <-> 10.0.0.0/16
data "aws_security_group" "since" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.since.id]
  }

  name = "default"
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
