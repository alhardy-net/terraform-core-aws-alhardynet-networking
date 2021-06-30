data "terraform_remote_state" "vpc-hub" {
  backend = "remote"
  config = {
    organization = "bytebox"
    workspaces = {
      name = "core-aws-alhardynet-networking-hub-prod"
    }
  }
}

data "terraform_remote_state" "vpc-stage" {
  backend = "remote"
  config = {
    organization = "bytebox"
    workspaces = {
      name = "core-aws-alhardynet-networking-vpc-stage"
    }
  }
}

data "terraform_remote_state" "vpc-prod" {
  backend = "remote"
  config = {
    organization = "bytebox"
    workspaces = {
      name = "core-aws-alhardynet-networking-vpc-prod"
    }
  }
}

module "vpc-peering-hub-stage" {
  source  = "grem11n/vpc-peering/aws"
  version = "4.0.1"

  providers = {
    aws.this = aws
    aws.peer = aws.stage
  }

  this_vpc_id = data.terraform_remote_state.vpc-hub.outputs.vpc_id
  peer_vpc_id = data.terraform_remote_state.vpc-stage.outputs.vpc_id

  auto_accept_peering = true

  tags = {
    Name        = "hub-stage"
  }
}

module "vpc-peering-hub-prod" {
  source  = "grem11n/vpc-peering/aws"
  version = "4.0.1"

  providers = {
    aws.this = aws
    aws.peer = aws.prod
  }

  this_vpc_id = data.terraform_remote_state.vpc-hub.outputs.vpc_id
  peer_vpc_id = data.terraform_remote_state.vpc-prod.outputs.vpc_id

  auto_accept_peering = true
  tags = {
    Name        = "hub-prod"
  }
}