module "lb_stockholm" {
  source = "./lb"

  vpc_id                 = module.vpc_stockholm.vpc_id
  subnets                = module.vpc_stockholm.subnet_ids
  default_security_group = module.vpc_stockholm.default_security_group_id
  target_port            = var.port
  certificate_arn        = "arn:aws:acm:eu-north-1:154782911265:certificate/6f6dc63b-9d52-4e6c-ae7e-69a8d76476bb"

  providers = {
    aws = aws.stockholm
  }
}

module "lb_ohio" {
  source = "./lb"

  vpc_id                 = module.vpc_ohio.vpc_id
  subnets                = module.vpc_ohio.subnet_ids
  default_security_group = module.vpc_ohio.default_security_group_id
  target_port            = var.port
  certificate_arn        = "arn:aws:acm:us-east-2:154782911265:certificate/8032fe1f-7f7d-4c6b-89ca-ba687020de1a"

  providers = {
    aws = aws.ohio
  }
}

module "lb_north_california" {
  source = "./lb"

  vpc_id                 = module.vpc_north_california.vpc_id
  subnets                = module.vpc_north_california.subnet_ids
  default_security_group = module.vpc_north_california.default_security_group_id
  target_port            = var.port
  certificate_arn        = "arn:aws:acm:us-west-1:154782911265:certificate/7b9b3231-f23b-41d1-994d-0f102cdebaaa"

  providers = {
    aws = aws.north_california
  }
}

module "lb_sydney" {
  source = "./lb"

  vpc_id                 = module.vpc_sydney.vpc_id
  subnets                = module.vpc_sydney.subnet_ids
  default_security_group = module.vpc_sydney.default_security_group_id
  target_port            = var.port
  certificate_arn        = "arn:aws:acm:ap-southeast-2:154782911265:certificate/e7dff32c-93cb-496d-a385-9db1fd44ba29"

  providers = {
    aws = aws.sydney
  }
}

module "lb_sao_paulo" {
  source = "./lb"

  vpc_id                 = module.vpc_sao_paulo.vpc_id
  subnets                = module.vpc_sao_paulo.subnet_ids
  default_security_group = module.vpc_sao_paulo.default_security_group_id
  target_port            = var.port
  certificate_arn        = "arn:aws:acm:sa-east-1:154782911265:certificate/4c281480-7200-4459-afd1-7697c1e06826"

  providers = {
    aws = aws.sao_paulo
  }
}
