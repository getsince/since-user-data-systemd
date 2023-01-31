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

module "lb_north_california" {
  source = "./lb"

  vpc_id                 = module.vpc_north_california.vpc_id
  subnets                = module.vpc_north_california.subnet_ids
  default_security_group = module.vpc_north_california.default_security_group_id
  target_port            = var.port
  certificate_arn        = "arn:aws:acm:us-west-1:154782911265:certificate/7b9b3231-f23b-41d1-994d-0f102cdebaaa"
  imgproxy_host          = var.imgproxy_host

  providers = {
    aws = aws.north_california
  }
}
