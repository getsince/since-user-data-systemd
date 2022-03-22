output "vpc_id" {
  value = data.aws_vpc.this.id
}

output "default_security_group_id" {
  value = data.aws_security_group.default.id
}

output "peering_security_group_ids" {
  value = data.aws_security_groups.peering.ids
}

output "subnet_ids" {
  value = data.aws_subnets.this.ids
}
