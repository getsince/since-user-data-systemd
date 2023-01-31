module "vpc_stockholm" {
  source = "./vpc"

  cidr = "10.0.0.0/16"

  providers = {
    aws = aws.stockholm
  }
}

module "vpc_north_california" {
  source = "./vpc"

  cidr = "10.2.0.0/16"

  providers = {
    aws = aws.north_california
  }
}
