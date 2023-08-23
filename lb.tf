module "lb_stockholm" {
  source = "./lb"

  vpc_id                 = module.vpc_stockholm.vpc_id
  subnets                = module.vpc_stockholm.subnet_ids
  default_security_group = module.vpc_stockholm.default_security_group_id
  target_port            = var.port
  certificate_arn        = "arn:aws:acm:eu-north-1:154782911265:certificate/6f6dc63b-9d52-4e6c-ae7e-69a8d76476bb"
  imgproxy_host          = var.imgproxy_host

  providers = {
    aws = aws.stockholm
  }
}
