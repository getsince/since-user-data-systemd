terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }

  required_version = "~> 1.1"
}

# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-latency-alias.html#rrsets-values-latency-alias-associate-with-health-check
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-determining-health-of-endpoints.html

resource "aws_route53_record" "a" {
  zone_id = var.route53_zone_id
  name    = var.host
  type    = "A"

  set_identifier = "backend/lb/a/${var.region}"

  alias {
    name    = var.lb_dns_name
    zone_id = var.lb_zone_id

    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.region
  }
}

resource "aws_route53_record" "aaaa" {
  zone_id = var.route53_zone_id
  name    = var.host
  type    = "AAAA"

  set_identifier = "backend/lb/aaaa/${var.region}"

  alias {
    name    = var.lb_dns_name
    zone_id = var.lb_zone_id

    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.region
  }
}
