variable "vpc_id" {}
variable "default_security_group" {}
variable "certificate_arn" {}

variable "target_port" {
  type = number
}

variable "subnets" {
  type = list(string)
}

