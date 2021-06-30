locals {
  name                            = "alhardynet"
  aws_region                      = "ap-southeast-2"
  public_subnet_cidr              = cidrsubnet(var.vpc_cidr, 4, 0)
  private_application_subnet_cidr = var.private_application_subnet_count > 0 ? cidrsubnet(var.vpc_cidr, 2, 1) : 0
  private_persistence_subnet_cidr = var.private_persistence_subnet_count > 0 ? cidrsubnet(var.vpc_cidr, 2, 2) : 0
}

module "aws-vpc" {
  source                        = "app.terraform.io/bytebox/aws-vpc/module"
  version                       = "0.0.1"
  aws_region                    = local.aws_region
  vpc_cidr                      = var.vpc_cidr
  enable_vpc_flow_log           = false # TODO: Enable this
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
  name                          = local.name
}

module "public-subnet" {
  source                 = "app.terraform.io/bytebox/aws-subnet-public/module"
  version                = "0.0.2"
  aws_region             = local.aws_region
  igw_id                 = module.aws-vpc.igw_id
  name                   = "${local.name}-public"
  enable_nat_gateway     = true
  use_single_nat_gateway = var.use_single_nat_gateway
  subnet_count           = var.public_subnet_count
  vpc_id                 = module.aws-vpc.vpc_id
  enable_flow_log        = false # TODO: Enable this
  subnet_cidr            = local.public_subnet_cidr
}

module "private-application-subnet" {
  source                = "app.terraform.io/bytebox/aws-subnet-private/module"
  version               = "0.0.2"
  aws_region            = local.aws_region
  enable_flow_log       = false # TODO: Enable this
  name                  = "${local.name}-private-application"
  nat_gateway_ids       = module.public-subnet.nat_gateway_ids
  subnet_cidr           = local.private_application_subnet_cidr
  subnet_count          = var.private_application_subnet_count
  vpc_id                = module.aws-vpc.vpc_id
  allow_internet_access = true
}

module "private-persistence-subnet" {
  source                = "app.terraform.io/bytebox/aws-subnet-private/module"
  version               = "0.0.2"
  aws_region            = local.aws_region
  enable_flow_log       = false # TODO: Enable this
  name                  = "${local.name}-private-persistence"
  nat_gateway_ids       = module.public-subnet.nat_gateway_ids
  subnet_cidr           = local.private_persistence_subnet_cidr
  subnet_count          = var.private_persistence_subnet_count
  vpc_id                = module.aws-vpc.vpc_id
  allow_internet_access = true
}

# TODO: Implement VPC Flow log module allow to create a S3 backed flow log for the VPC and Subnets