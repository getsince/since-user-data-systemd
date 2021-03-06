variable "instance_name" {}

variable "min_size" {
  type    = number
  default = 1
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 10
}

variable "on_demand_base_capacity" {
  type    = number
  default = 0
}

variable "user_data_base64" {}

variable "security_groups" {
  type = list(string)
}

variable "instance_types" {
  type = list(string)
}

variable "lb_target_group_arns" {
  type = list(string)
}

variable "vpc_zone_identifier" {
  type = list(string)
}

data "aws_ami" "ubuntu_amd" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-jammy-22.04-amd64-minimal-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
