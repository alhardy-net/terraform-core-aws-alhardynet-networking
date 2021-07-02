locals {
  name                   = "alhardynet-hub"
  public_vpn_subnet_cidr = cidrsubnet(var.vpc_cidr, 6, 0)
  private_subnet_cidr    = cidrsubnet(var.vpc_cidr, 6, 1)
}

module "aws-vpc" {
  source                        = "app.terraform.io/bytebox/aws-vpc/module"
  version                       = "0.0.2"
  aws_region                    = var.aws_region
  vpc_cidr                      = var.vpc_cidr
  manage_default_security_group = true
  manage_default_network_acl    = false
  manage_default_route_table    = false
  name                          = local.name
}

module "flow_logs" {
  source  = "cloudposse/vpc-flow-logs-s3-bucket/aws"
  version = "0.12.1"

  namespace = local.name
  name      = "flowlogs"

  vpc_id = module.aws-vpc.vpc_id
}

module "public-subnet" {
  source             = "app.terraform.io/bytebox/aws-subnet-public/module"
  version            = "0.0.3"
  aws_region         = var.aws_region
  igw_id             = module.aws-vpc.igw_id
  name               = "${local.name}-vpn-public"
  enable_nat_gateway = false
  subnet_count       = var.public_vpn_subnet_count
  vpc_id             = module.aws-vpc.vpc_id
  subnet_cidr        = local.public_vpn_subnet_cidr
}

module "private-subnet" {
  source                = "app.terraform.io/bytebox/aws-subnet-private/module"
  version               = "0.0.3"
  aws_region            = var.aws_region
  name                  = "${local.name}-private"
  nat_gateway_ids       = []
  subnet_cidr           = local.private_subnet_cidr
  subnet_count          = var.private_subnet_count
  vpc_id                = module.aws-vpc.vpc_id
  allow_internet_access = false
}