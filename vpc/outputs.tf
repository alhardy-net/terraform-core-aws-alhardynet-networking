output "vpc_id" {
  value       = module.aws-vpc.vpc_id
  description = "The VPC Identifier"
}

output "vpc_cidr_block" {
  value       = var.vpc_cidr
  description = "The CIDR block of the VPC"
}

output "public_subnets" {
  value       = module.public-subnet.subnet_ids
  description = "The Public Subnet Identifiers"
}

output "private_application_subnets" {
  value       = module.private-application-subnet.subnet_ids
  description = "The Private Application Subnet Identifiers"
}

output "private_persistence_subnets" {
  value       = module.private-persistence-subnet.subnet_ids
  description = "The Private Persistence Subnet Identifiers"
}