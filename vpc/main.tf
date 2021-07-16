locals {
  name                            = "alhardynet"
  aws_region                      = "ap-southeast-2"
  tfc_workspace_slug_parts        = split("-", var.TFC_WORKSPACE_SLUG)
  env                             = element(local.tfc_workspace_slug_parts, length(local.tfc_workspace_slug_parts) - 1)
  public_subnet_cidr              = cidrsubnet(var.vpc_cidr, 4, 0)
  private_application_subnet_cidr = var.private_application_subnet_count > 0 ? cidrsubnet(var.vpc_cidr, 2, 1) : 0
  private_persistence_subnet_cidr = var.private_persistence_subnet_count > 0 ? cidrsubnet(var.vpc_cidr, 2, 2) : 0
}

resource "random_integer" "random" {
  min = 1
  max = 99
}

module "aws-vpc" {
  source                        = "app.terraform.io/bytebox/aws-vpc/module"
  version                       = "0.0.2"
  aws_region                    = local.aws_region
  vpc_cidr                      = var.vpc_cidr
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
  name                          = local.name
  TFC_WORKSPACE_SLUG            = var.TFC_WORKSPACE_SLUG
}

module "flow_logs" {
  source  = "cloudposse/vpc-flow-logs-s3-bucket/aws"
  version = "0.12.1"

  namespace = local.name
  name      = "flowlogs-${local.env}"

  vpc_id = module.aws-vpc.vpc_id
}

module "public-subnet" {
  source                 = "app.terraform.io/bytebox/aws-subnet-public/module"
  version                = "0.0.3"
  aws_region             = local.aws_region
  igw_id                 = module.aws-vpc.igw_id
  name                   = "${local.name}-public"
  enable_nat_gateway     = var.enable_nat_gateway
  use_single_nat_gateway = var.use_single_nat_gateway
  subnet_count           = var.public_subnet_count
  vpc_id                 = module.aws-vpc.vpc_id
  subnet_cidr            = local.public_subnet_cidr
  TFC_WORKSPACE_SLUG     = var.TFC_WORKSPACE_SLUG
}

module "private-application-subnet" {
  source                = "app.terraform.io/bytebox/aws-subnet-private/module"
  version               = "0.0.3"
  aws_region            = local.aws_region
  name                  = "${local.name}-private-application"
  nat_gateway_ids       = var.enable_nat_gateway ? module.public-subnet.nat_gateway_ids : []
  subnet_cidr           = local.private_application_subnet_cidr
  subnet_count          = var.private_application_subnet_count
  vpc_id                = module.aws-vpc.vpc_id
  allow_internet_access = var.enable_nat_gateway
  TFC_WORKSPACE_SLUG    = var.TFC_WORKSPACE_SLUG
}

module "private-persistence-subnet" {
  source                = "app.terraform.io/bytebox/aws-subnet-private/module"
  version               = "0.0.3"
  aws_region            = local.aws_region
  name                  = "${local.name}-private-persistence"
  nat_gateway_ids       = var.enable_nat_gateway && var.private_persistence_subnet_enable_nat_gateway ? module.public-subnet.nat_gateway_ids : []
  subnet_cidr           = local.private_persistence_subnet_cidr
  subnet_count          = var.private_persistence_subnet_count
  vpc_id                = module.aws-vpc.vpc_id
  allow_internet_access = var.private_persistence_subnet_enable_nat_gateway
  TFC_WORKSPACE_SLUG    = var.TFC_WORKSPACE_SLUG
}