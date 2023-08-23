module "vpc_stockholm" {
  source = "./vpc"

  cidr = "10.0.0.0/16"

  providers = {
    aws = aws.stockholm
  }
}
