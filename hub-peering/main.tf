module "vpc-peering-hub-stage" {
  source  = "grem11n/vpc-peering/aws"
  version = "4.0.1"

  providers = {
    aws.this = aws
    aws.peer = aws.stage
  }

  this_vpc_id = var.hub_vpc_id
  peer_vpc_id = var.stage_vpc_id

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

  this_vpc_id = var.hub_vpc_id
  peer_vpc_id = var.prod_vpc_id

  auto_accept_peering = true
  tags = {
    Name        = "hub-prod"
  }
}