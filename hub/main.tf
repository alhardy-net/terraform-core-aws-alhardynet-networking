locals {
  name = "alhardynet-hub"
}

module "aws-vpc" {
  source                        = "app.terraform.io/bytebox/aws-vpc/module"
  version                       = "0.0.2"
  aws_region                    = var.aws_region
  vpc_cidr                      = var.vpc_cidr
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
  name                          = local.name
}

module "flow_logs" {
  source  = "cloudposse/vpc-flow-logs-s3-bucket/aws"
  version = "0.12.1"

  namespace  = local.name
  name       = "flowlogs"

  vpc_id = module.aws-vpc.vpc_id
}