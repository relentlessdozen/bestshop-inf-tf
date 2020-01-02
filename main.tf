provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "shopadmin"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "bestshop-prod"

  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/25", "10.0.2.0/25"]
  public_subnets  = ["10.0.101.0/25", "10.0.102.0/25"]

  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "bestshop-pub"
  }

  tags = {
    Group       = "DevSecOps"
    Environment = "prod"
  }

  vpc_tags = {
    Name = "bestshop-prod-vpc"
  }

  resource "aws_security_group" "bestshop-sg1" {
    name        = "bestshop-sg1"
    description = "Best Shop main security group"
    vpc_id      = module.vpc.vpc_id
  }

  #data "aws_security_group" "bestshop-sg1" {
  #  name   = "bestshop-sg1"
  #  vpc_id = module.vpc.vpc_id
  #}
}
