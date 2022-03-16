data "aws_route53_zone" "getsince" {
  name = "getsince.app."
}

# TODO aws_route53_health_check
# TODO failover_routing_policy?

resource "aws_route53_record" "a" {
  zone_id = data.aws_route53_zone.getsince.zone_id
  name    = var.host
  type    = "A"

  set_identifier = "ruslan/lb/a/eu-north-1"

  alias {
    name    = aws_lb.ruslan.dns_name
    zone_id = aws_lb.ruslan.zone_id

    # https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-latency-alias.html#rrsets-values-latency-alias-associate-with-health-check
    # https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-determining-health-of-endpoints.html
    # evaluate_target_health = true
  }

  latency_routing_policy {
    region = "eu-north-1"
  }
}

resource "aws_route53_record" "aaaa" {
  zone_id = data.aws_route53_zone.getsince.zone_id
  name    = var.host
  type    = "AAAA"

  set_identifier = "ruslan/lb/aaaa/eu-north-1"

  alias {
    name    = aws_lb.ruslan.dns_name
    zone_id = aws_lb.ruslan.zone_id

    # evaluate_target_health = true
  }

  latency_routing_policy {
    region = "eu-north-1"
  }
}
