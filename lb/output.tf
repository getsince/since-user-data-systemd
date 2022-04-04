output "target_group_arns" {
  value = [
    aws_lb_target_group.api.arn,
    aws_lb_target_group.imgproxy.arn
  ]
}

output "zone_id" {
  value = aws_lb.this.zone_id
}

output "dns_name" {
  value = aws_lb.this.dns_name
}
