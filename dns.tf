data "aws_route53_zone" "getsince" {
  name = "getsince.app."
}

# # TODO aws_route53_health_check
# # TODO failover_routing_policy?

module "dns_stockholm" {
  source = "./dns"

  route53_zone_id = data.aws_route53_zone.getsince.zone_id

  lb_dns_name = module.lb_stockholm.dns_name
  lb_zone_id  = module.lb_stockholm.zone_id

  host   = var.host
  region = "eu-north-1"

  providers = {
    aws = aws.stockholm
  }
}

module "dns_north_california" {
  source = "./dns"

  route53_zone_id = data.aws_route53_zone.getsince.zone_id

  lb_dns_name = module.lb_north_california.dns_name
  lb_zone_id  = module.lb_north_california.zone_id

  host   = var.host
  region = "us-west-1"

  providers = {
    aws = aws.north_california
  }
}

resource "aws_route53_record" "imgproxy_a" {
  zone_id = data.aws_route53_zone.getsince.zone_id
  name    = var.imgproxy_host
  type    = "A"

  alias {
    name    = module.lb_stockholm.dns_name
    zone_id = module.lb_stockholm.zone_id

    evaluate_target_health = false
  }
}

resource "aws_route53_record" "imgproxy_aaaa" {
  zone_id = data.aws_route53_zone.getsince.zone_id
  name    = var.imgproxy_host
  type    = "AAAA"

  alias {
    name    = module.lb_stockholm.dns_name
    zone_id = module.lb_stockholm.zone_id

    evaluate_target_health = false
  }
}
