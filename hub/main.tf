locals {
  name = "alhardynet"
}

module "aws-vpc" {
  source                        = "app.terraform.io/bytebox/aws-vpc/module"
  version                       = "0.0.1"
  aws_region                    = var.aws_region
  vpc_cidr                      = var.vpc_cidr
  enable_vpc_flow_log           = false # TODO: Enable this
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
  name                          = local.name
}

# TODO: Implement VPC Flow log module allow to create a S3 backed flow log for the VPC and Subnets